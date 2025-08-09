#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

console.log('👁️ Improved Rule Watcher started');
console.log('   Checking rules every 10 seconds with detailed logging...\n');

// Check rules every 10 seconds (more frequent for debugging)
setInterval(() => {
  checkRules();
}, 10000);

// Also check immediately
checkRules();

function checkRules() {
  const timestamp = new Date().toLocaleTimeString();
  console.log(`⏰ [${timestamp}] Checking rules...`);
  
  const rulesFile = path.join(PORT42_HOME, 'memory', 'rules.json');
  const memoryFile = path.join(PORT42_HOME, 'memory', 'commands.json');
  
  if (!fs.existsSync(rulesFile)) {
    console.log('   📝 No rules file found, skipping check\n');
    return;
  }
  
  if (!fs.existsSync(memoryFile)) {
    console.log('   💾 No commands file found, skipping check\n');
    return;
  }
  
  try {
    const rules = JSON.parse(fs.readFileSync(rulesFile));
    const memory = JSON.parse(fs.readFileSync(memoryFile));
    
    console.log(`   📊 ${rules.length} rules, ${memory.commands?.length || 0} commands`);
    
    let rulesChanged = false;
    
    rules.forEach((rule, index) => {
      if (rule.executed) {
        return; // Skip already executed rules
      }
      
      console.log(`   🔍 Checking rule ${index + 1}: "${rule.description}"`);
      
      let shouldTrigger = false;
      
      // Check count-based rules (e.g., "whenever I have 3 commands with 'show'")
      if (rule.when?.type === 'count') {
        const pattern = rule.when.pattern || '';
        const threshold = rule.when.threshold || 3;
        
        const commands = memory.commands?.filter(c => {
          const matches = c.name.toLowerCase().includes(pattern.toLowerCase());
          if (matches) console.log(`      Found matching command: ${c.name}`);
          return matches;
        }) || [];
        
        console.log(`      Pattern '${pattern}': ${commands.length}/${threshold} commands`);
        shouldTrigger = commands.length >= threshold;
        
      // Check pattern-based rules (e.g., "whenever echo-nice exists")  
      } else if (rule.when?.type === 'pattern') {
        const pattern = rule.when.pattern || '';
        const threshold = rule.when.threshold || 1;
        
        const matches = memory.commands?.filter(c => 
          c.name.toLowerCase().includes(pattern.toLowerCase())) || [];
        
        console.log(`      Pattern '${pattern}': ${matches.length}/${threshold} matches`);
        shouldTrigger = matches.length >= threshold;
        
      // Check combination rules (e.g., "combine cmd1 and cmd2")
      } else if (rule.when?.type === 'combination') {
        if (!rule.when.commands) {
          console.log(`      ❌ Combination rule missing commands array`);
          return;
        }
        
        const exists = rule.when.commands.every(cmd => {
          const cmdPath = path.join(PORT42_HOME, 'bin', cmd);
          const exists = fs.existsSync(cmdPath);
          console.log(`      Command '${cmd}': ${exists ? '✅' : '❌'}`);
          return exists;
        });
        
        shouldTrigger = exists;
        
      // Check time-based rules  
      } else if (rule.when?.type === 'time') {
        const hour = new Date().getHours();
        const today = new Date().toDateString();
        const targetHour = rule.when.hour || 9;
        
        console.log(`      Time check: ${hour} === ${targetHour}, last: ${rule.lastExecuted}`);
        shouldTrigger = hour === targetHour && rule.lastExecuted !== today;
        
      } else {
        console.log(`      ❓ Unknown rule type: ${rule.when?.type}`);
      }
      
      if (shouldTrigger) {
        console.log(`   🚀 TRIGGERING RULE: ${rule.description}`);
        executeRule(rule);
        rule.executed = true;
        rulesChanged = true;
      } else {
        console.log(`   💤 Rule not ready to trigger`);
      }
    });
    
    // Save rules if any were executed
    if (rulesChanged) {
      fs.writeFileSync(rulesFile, JSON.stringify(rules, null, 2));
      console.log('   💾 Rules file updated with execution status');
    }
    
  } catch (e) {
    console.error('   ❌ Error checking rules:', e.message);
  }
  
  console.log('');
}

function executeRule(rule) {
  console.log(`\n🧬 === RULE EXECUTION ===`);
  console.log(`Rule: ${rule.description}`);
  console.log(`Action: ${rule.then?.type || 'unknown'}`);
  
  if (rule.then?.type === 'spawn_command') {
    const cmdName = rule.then.name || generateCommandName(rule.description);
    
    // Try to get better command content based on Claude if available
    let commandContent = '';
    if (rule.then.action && rule.then.action !== 'Create based on pattern') {
      commandContent = rule.then.action;
    } else {
      commandContent = `# TODO: Implement functionality for: ${rule.description}
echo "🧬 This command was auto-spawned!"
echo "Rule: ${rule.description}"
echo ""
echo "Edit me at: ~/.port42-premise/bin/${cmdName}"`;
    }
    
    const code = `#!/bin/bash
# Auto-spawned by rule: ${rule.description}
# Generated at: ${new Date().toISOString()}

${commandContent}`;

    const cmdPath = path.join(PORT42_HOME, 'bin', cmdName);
    fs.writeFileSync(cmdPath, code);
    fs.chmodSync(cmdPath, '755');
    
    console.log(`✨ Spawned new command: ${cmdName}`);
    console.log(`📁 Location: ${cmdPath}`);
    
    // Also log to commands memory
    logNewCommand(cmdName, 'auto-spawned by rule');
    
  } else if (rule.then?.type === 'combine_commands') {
    console.log(`🔀 Would combine commands (not yet implemented)`);
    
  } else {
    console.log(`❓ Unknown action type: ${rule.then?.type}`);
  }
  
  console.log(`=== END RULE EXECUTION ===\n`);
}

function generateCommandName(description) {
  const words = description.toLowerCase()
    .replace(/[^a-z0-9 ]/g, '')
    .split(' ')
    .filter(w => w.length > 2 && !['the', 'and', 'for', 'that', 'this', 'with', 'whenever', 'create'].includes(w))
    .slice(0, 2);
  
  if (words.length > 0) {
    return words.join('-');
  }
  
  return `auto-cmd-${Date.now().toString(36)}`;
}

function logNewCommand(name, source) {
  const memoryFile = path.join(PORT42_HOME, 'memory', 'commands.json');
  let memory = { commands: [] };
  
  if (fs.existsSync(memoryFile)) {
    try {
      memory = JSON.parse(fs.readFileSync(memoryFile));
    } catch (e) {
      memory = { commands: [] };
    }
  }
  
  memory.commands.push({
    name,
    created: new Date().toISOString(),
    generatedBy: 'rule-watcher',
    powered_by: 'rule-engine',
    source
  });
  
  fs.writeFileSync(memoryFile, JSON.stringify(memory, null, 2));
  console.log(`💾 Logged new command to memory: ${name}`);
}
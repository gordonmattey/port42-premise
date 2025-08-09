#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

console.log('🔍 Debug Rule Watcher - Analyzing why rules aren\'t triggering\n');

function debugCheckRules() {
  const rulesFile = path.join(PORT42_HOME, 'memory', 'rules.json');
  const memoryFile = path.join(PORT42_HOME, 'memory', 'commands.json');
  
  console.log('📍 Files being checked:');
  console.log(`   Rules: ${rulesFile}`);
  console.log(`   Memory: ${memoryFile}\n`);
  
  // Check if files exist
  if (!fs.existsSync(rulesFile)) {
    console.log('❌ No rules.json file found');
    return;
  }
  
  if (!fs.existsSync(memoryFile)) {
    console.log('❌ No commands.json file found');
    return;
  }
  
  try {
    const rulesContent = fs.readFileSync(rulesFile, 'utf8');
    const memoryContent = fs.readFileSync(memoryFile, 'utf8');
    
    console.log('📜 Raw rules.json content:');
    console.log(rulesContent);
    console.log('\n💾 Raw commands.json content:');
    console.log(memoryContent);
    console.log('\n' + '='.repeat(50) + '\n');
    
    const rules = JSON.parse(rulesContent);
    const memory = JSON.parse(memoryContent);
    
    console.log(`📊 Found ${rules.length} rules and ${memory.commands?.length || 0} commands\n`);
    
    rules.forEach((rule, index) => {
      console.log(`🔍 Rule ${index + 1}: "${rule.description}"`);
      console.log(`   Type: ${rule.when?.type || 'undefined'}`);
      console.log(`   Pattern: ${rule.when?.pattern || 'undefined'}`);
      console.log(`   Threshold: ${rule.when?.threshold || 'undefined'}`);
      console.log(`   Executed: ${rule.executed || false}`);
      
      // Debug each rule type
      if (rule.when?.type === 'count') {
        const commands = memory.commands?.filter(c => 
          c.name.includes(rule.when.pattern || '')) || [];
        console.log(`   Found ${commands.length} matching commands:`);
        commands.forEach(cmd => console.log(`     - ${cmd.name}`));
        console.log(`   Should trigger: ${commands.length >= (rule.when.threshold || 3)}`);
        
      } else if (rule.when?.type === 'pattern') {
        const matches = memory.commands?.filter(c => 
          c.name.includes(rule.when.pattern)) || [];
        console.log(`   Found ${matches.length} pattern matches:`);
        matches.forEach(cmd => console.log(`     - ${cmd.name}`));
        console.log(`   Should trigger: ${matches.length >= (rule.when.threshold || 1)}`);
        
      } else if (rule.when?.type === 'combination') {
        const exists = rule.when.commands?.every(cmd => {
          const cmdPath = path.join(PORT42_HOME, 'bin', cmd);
          const exists = fs.existsSync(cmdPath);
          console.log(`     Command '${cmd}' exists: ${exists}`);
          return exists;
        }) || false;
        console.log(`   All commands exist: ${exists}`);
        console.log(`   Should trigger: ${exists && !rule.executed}`);
        
      } else if (rule.when?.type === 'time') {
        const hour = new Date().getHours();
        const today = new Date().toDateString();
        const targetHour = rule.when.hour || 9;
        console.log(`   Current hour: ${hour}, Target: ${targetHour}`);
        console.log(`   Last executed: ${rule.lastExecuted || 'never'}`);
        console.log(`   Today: ${today}`);
        console.log(`   Should trigger: ${hour === targetHour && rule.lastExecuted !== today}`);
      } else {
        console.log(`   ❓ Unknown rule type: ${rule.when?.type}`);
      }
      
      console.log('');
    });
    
  } catch (e) {
    console.error('❌ Error reading/parsing files:', e.message);
  }
}

debugCheckRules();
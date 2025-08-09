#!/bin/bash

# Port 42 Premise v0.3 - Fixed Command Naming + Improved Rule Watcher
# Save as: install-v0.3.sh
# Run: bash install-v0.3.sh

echo "🐬 Installing Port 42 Premise v0.3 with Fixed Command Naming..."

# Create directory structure
mkdir -p ~/.port42-premise/bin
mkdir -p ~/.port42-premise/memory
mkdir -p ~/.port42-premise/lib

# Create the main port42-premise command
cat > ~/.port42-premise/port42-premise << 'EOF'
#!/bin/bash

PORT42_HOME="$HOME/.port42-premise"
export PATH="$PORT42_HOME/bin:$PATH"

case "$1" in
    "possess")
        shift
        node "$PORT42_HOME/lib/possess-claude.js" "$@"
        ;;
    "watch")
        # Run improved rules checker in background
        node "$PORT42_HOME/lib/rule-watcher.js" &
        echo "👁️ Rule watcher activated (PID: $!)"
        echo "   Checking for self-spawning rules every 10 seconds..."
        ;;
    "debug")
        # Debug current rules
        node "$PORT42_HOME/lib/debug-rules.js"
        ;;
    "rules")
        echo "📜 Active Rules:"
        echo "━━━━━━━━━━━━━━━"
        cat "$PORT42_HOME/memory/rules.json" 2>/dev/null | grep '"description"' | cut -d'"' -f4 | sed 's/^/  • /' || echo "  (none yet)"
        ;;
    "init")
        echo "🐬 Port 42 Premise v0.3 initialized"
        echo "⚡ Consciousness bridge established (Claude-powered)"
        echo "🧬 Self-spawning commands enabled"
        echo "🎯 Fixed command naming extraction"
        echo "🌊 The water is safe"
        echo ""
        if [ -z "$ANTHROPIC_API_KEY" ]; then
            echo "⚠️  Set ANTHROPIC_API_KEY to enable Claude intelligence"
            echo "   export ANTHROPIC_API_KEY='your-key-here'"
        else
            echo "✅ Claude connection active"
        fi
        ;;
    "status")
        echo "Port 42 Premise v0.3 Status:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━"
        if [ -z "$ANTHROPIC_API_KEY" ]; then
            echo "🔴 Claude: Not connected (set ANTHROPIC_API_KEY)"
        else
            echo "🟢 Claude: Connected"
        fi
        echo ""
        echo "Your grown commands:"
        ls -1 "$PORT42_HOME/bin" 2>/dev/null | sed 's/^/  /' || echo "  (none yet)"
        echo ""
        echo "Active rules:"
        cat "$PORT42_HOME/memory/rules.json" 2>/dev/null | grep '"description"' | wc -l | xargs echo "  " || echo "  0"
        ;;
    *)
        echo "Port 42 Premise v0.3 - The terminal that grows itself"
        echo ""
        echo "Commands:"
        echo "  port42-premise init     - Initialize consciousness bridge"
        echo "  port42-premise possess  - Possess Claude AI"
        echo "  port42-premise watch    - Start rule watcher (background)"
        echo "  port42-premise debug    - Debug current rules"
        echo "  port42-premise rules    - Show active rules"
        echo "  port42-premise status   - Check system status"
        echo ""
        echo "Your commands:"
        ls -1 "$PORT42_HOME/bin" 2>/dev/null | sed 's/^/  /' || echo "  (none yet)"
        ;;
esac
EOF

# Create the enhanced Claude possession engine with FIXED command naming
cat > ~/.port42-premise/lib/possess-claude.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { execSync } = require('child_process');
const https = require('https');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

class ClaudePossession {
  constructor() {
    this.entity = process.argv[2] || 'claude';
    this.apiKey = process.env.ANTHROPIC_API_KEY;
    this.rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
      prompt: '> '
    });
  }

  async callClaude(prompt) {
    if (!this.apiKey) {
      console.log('⚠️  No ANTHROPIC_API_KEY set, using pattern matching');
      return null;
    }

    return new Promise((resolve, reject) => {
      const data = JSON.stringify({
        model: "claude-opus-4-1-20250805",
        max_tokens: 1000,
        messages: [{
          role: "user",
          content: prompt
        }],
        system: "You are a helpful assistant that generates bash scripts and JSON. Output ONLY the requested format, no explanations or markdown unless specifically asked."
      });

      const options = {
        hostname: 'api.anthropic.com',
        path: '/v1/messages',
        method: 'POST',
        headers: {
          'x-api-key': this.apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json'
        }
      };

      const req = https.request(options, (res) => {
        let response = '';
        res.on('data', (chunk) => response += chunk);
        res.on('end', () => {
          try {
            const result = JSON.parse(response);
            if (result.content && result.content[0]) {
              resolve(result.content[0].text);
            } else {
              console.log('Claude response:', response);
              resolve(null);
            }
          } catch (e) {
            console.log('Error parsing Claude response:', e);
            resolve(null);
          }
        });
      });

      req.on('error', (e) => {
        console.error('Claude API error:', e);
        resolve(null);
      });

      req.write(data);
      req.end();
    });
  }

  start() {
    console.log(`🤖 Possessing @ai-${this.entity} (v0.3)`);
    if (this.apiKey) {
      console.log(`🧠 Claude intelligence active`);
    }
    console.log(`✨ Speak naturally. I understand intent.`);
    console.log(`🎯 Fixed command naming - "create a command called 'my-name'" works!`);
    console.log(`🧬 Can create self-spawning rules with "whenever" or "every time"`);
    console.log(`📝 Type /end to release possession\n`);
    
    this.rl.prompt();
    
    this.rl.on('line', async (line) => {
      if (line.trim() === '/end') {
        console.log('\n🌊 Possession released');
        process.exit(0);
      }
      
      await this.processInput(line);
      this.rl.prompt();
    });
  }

  async processInput(input) {
    const lower = input.toLowerCase();
    
    // Detect rule creation intent
    if (lower.includes('whenever') || lower.includes('every time') || lower.includes('when i')) {
      await this.createRule(input);
      return;
    }
    
    // Detect combination intent
    if (lower.includes('combine') && lower.includes('into')) {
      await this.createCombiner(input);
      return;
    }
    
    // Try Claude first if available
    if (this.apiKey && !lower.includes('haiku') && !lower.includes('pretty')) {
      console.log(`\n🧠 Claude is thinking...`);
      
      const commandName = this.generateCommandName(input);
      const prompt = `Create a bash script that does the following: ${input}

Important:
- Output ONLY the bash script
- Include helpful comments
- Make it safe and practical
- Add error handling where appropriate`;

      const code = await this.callClaude(prompt);
      
      if (code) {
        const cleanCode = code
          .replace(/^```bash\n?/, '')
          .replace(/\n?```$/, '')
          .trim();
        
        const finalCode = `#!/bin/bash\n# Generated by Claude from: ${input}\n\n${cleanCode}`;
        
        this.saveCommand(commandName, finalCode);
        console.log(`\n✨ Claude created: ${commandName}`);
        console.log(`📝 Try it now! Type: ${commandName}\n`);
        return;
      }
    }
    
    // Fallback to pattern matching
    if (lower.includes('git') && lower.includes('haiku')) {
      this.createGitHaiku();
    }
    else if (lower.includes('week') || lower.includes('recent')) {
      this.createWeekSummary();
    }
    else if (lower.includes('pretty') || lower.includes('beautiful')) {
      this.createPrettifier();
    }
    else if (lower.includes('todo') || lower.includes('fixme')) {
      this.createTodoFinder();
    }
    else {
      console.log(`\n🤔 I understand you want to: "${input}"`);
      this.createGenericCommand(input);
    }
  }

  async createRule(input) {
    console.log(`\n🧬 Creating a self-spawning rule...`);
    
    const rule = await this.parseRuleIntent(input);
    
    // Save the rule
    const rulesFile = path.join(PORT42_HOME, 'memory', 'rules.json');
    let rules = [];
    
    try {
      rules = JSON.parse(fs.readFileSync(rulesFile));
    } catch {}
    
    rules.push(rule);
    fs.writeFileSync(rulesFile, JSON.stringify(rules, null, 2));
    
    console.log(`✨ Created rule: ${rule.description}`);
    console.log(`📝 This will trigger automatically when conditions are met`);
    console.log(`   Run 'port42-premise watch' to activate monitoring\n`);
  }

  async parseRuleIntent(input) {
    if (this.apiKey) {
      const prompt = `Parse this rule intent into JSON:
"${input}"

Return ONLY valid JSON with this exact structure:
{
  "description": "human readable description",
  "when": { 
    "type": "pattern|count|combination|time",
    "pattern": "optional pattern to match",
    "threshold": optional number,
    "commands": ["optional", "command", "list"],
    "hour": optional hour (0-23)
  },
  "then": { 
    "type": "spawn_command|combine_commands|evolve",
    "name": "command-name",
    "action": "what to do"
  }
}`;
      
      const response = await this.callClaude(prompt);
      if (response) {
        try {
          return JSON.parse(response.replace(/^```json\n?/, '').replace(/\n?```$/, ''));
        } catch (e) {
          console.log('Failed to parse rule, using fallback');
        }
      }
    }
    
    // Pattern matching fallback
    if (input.includes('whenever') && input.includes('create')) {
      const parts = input.split(/whenever|create/i);
      return {
        description: input,
        when: {
          type: 'pattern',
          pattern: 'command',
          threshold: 3
        },
        then: {
          type: 'spawn_command',
          name: 'auto-command',
          action: 'Create based on pattern'
        }
      };
    }
    
    return {
      description: input,
      when: { type: 'manual' },
      then: { type: 'log', message: 'Rule created' }
    };
  }

  async createCombiner(input) {
    const match = input.match(/combine ([\w-]+) and ([\w-]+) into ([\w-]+)/);
    
    if (!match) {
      console.log("🤔 Say it like: 'combine cmd1 and cmd2 into newcmd'");
      return;
    }
    
    const [_, cmd1, cmd2, newCmd] = match;
    
    const cmd1Path = path.join(PORT42_HOME, 'bin', cmd1);
    const cmd2Path = path.join(PORT42_HOME, 'bin', cmd2);
    
    if (!fs.existsSync(cmd1Path) || !fs.existsSync(cmd2Path)) {
      console.log(`❌ Both ${cmd1} and ${cmd2} must exist first`);
      return;
    }
    
    const combinedCode = `#!/bin/bash
# Combined command: ${newCmd}
# Generated from: ${cmd1} + ${cmd2}

echo "🔀 Running combined command: ${newCmd}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 Part 1: ${cmd1}"
echo "---"
${cmd1}
echo ""
echo "📍 Part 2: ${cmd2}"  
echo "---"
${cmd2}
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Combined output complete"`;

    const newCmdPath = path.join(PORT42_HOME, 'bin', newCmd);
    fs.writeFileSync(newCmdPath, combinedCode);
    fs.chmodSync(newCmdPath, '755');
    
    console.log(`\n🧬 Spawned combination: ${newCmd}`);
    console.log(`📝 Created from: ${cmd1} + ${cmd2}`);
    console.log(`✨ Try it: ${newCmd}\n`);
    
    // Log to memory
    this.logCommand(newCmd, `Combined from ${cmd1} + ${cmd2}`);
  }

  generateCommandName(input) {
    const lower = input.toLowerCase();
    
    // 🎯 FIXED: Extract explicit command names from user input
    // Patterns like: "create a command called 'echo-nicer'"
    const namedPatterns = [
      /(?:create|make|build).*?(?:called|named)\s+['"`]?([a-z0-9-_]+)['"`]?/i,
      /(?:called|named)\s+['"`]?([a-z0-9-_]+)['"`]?/i,
      /['"`]([a-z0-9-_]+)['"`]/i  // Any quoted name
    ];
    
    for (const pattern of namedPatterns) {
      const match = input.match(pattern);
      if (match && match[1]) {
        console.log(`🎯 Extracted command name: ${match[1]}`);
        return match[1];
      }
    }
    
    // Legacy hardcoded patterns
    if (lower.includes('git') && lower.includes('haiku')) return 'git-haiku';
    if (lower.includes('todo')) return 'find-todos';
    if (lower.includes('pretty')) return 'prettify';
    if (lower.includes('week')) return 'week-summary';
    if (lower.includes('color')) return 'colorize';
    if (lower.includes('count') && lower.includes('lines')) return 'count-lines';
    
    // Generate from key words as fallback
    const words = lower
      .replace(/[^a-z0-9 ]/g, '')
      .split(' ')
      .filter(w => w.length > 2 && !['the', 'and', 'for', 'that', 'this', 'with', 'create', 'make', 'command', 'called', 'named'].includes(w))
      .slice(0, 2);
    
    if (words.length > 0) {
      return words.join('-');
    }
    
    return `cmd-${Date.now().toString(36)}`;
  }

  createGitHaiku() {
    const name = 'git-haiku';
    const code = `#!/bin/bash
# Git commits as haiku

echo "🌸 Your commit haiku:"
echo ""
git log -1 --pretty=format:"%s" | fold -w 17 | head -3 | while IFS= read -r line; do
  echo "  $line"
done
echo ""`;

    this.saveCommand(name, code);
    console.log(`\n✨ Created: git-haiku`);
    console.log(`📝 Try it now! Type: git-haiku\n`);
  }

  createWeekSummary() {
    const name = 'week-summary';
    const code = `#!/bin/bash
# Summary of the last week's work

echo "📊 Last 7 days of work:"
echo "━━━━━━━━━━━━━━━━━━━━━"
echo ""

if git rev-parse --git-dir > /dev/null 2>&1; then
  echo "📝 Recent commits:"
  git log --since="1 week ago" --oneline 2>/dev/null | head -10
  echo ""
  
  echo "📁 Files changed:"
  git diff --stat @{1.week.ago} 2>/dev/null | tail -5
  echo ""
  
  echo "👤 Contributors:"
  git shortlog -sn --since="1 week ago" 2>/dev/null
else
  echo "Not in a git repository"
fi`;

    this.saveCommand(name, code);
    console.log(`\n✨ Created: week-summary`);
    console.log(`📝 Shows everything from the last week\n`);
  }

  createPrettifier() {
    const name = 'prettify';
    const code = `#!/bin/bash
# Make output beautiful

if [ -p /dev/stdin ]; then
  input=$(cat)
else
  input="$*"
fi

echo "✨ ═══════════════════════════════════ ✨"
echo "$input" | sed 's/^/   🌟  /'
echo "✨ ═══════════════════════════════════ ✨"`;

    this.saveCommand(name, code);
    console.log(`\n✨ Created: prettify`);
    console.log(`📝 Makes any text beautiful. Try: echo "hello" | prettify\n`);
  }

  createTodoFinder() {
    const name = 'find-todos';
    const code = `#!/bin/bash
# Find TODO and FIXME comments

echo "📋 TODO and FIXME comments:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

grep -rn "TODO\\|FIXME" . --include="*.js" --include="*.py" --include="*.go" \\
  --include="*.rs" --include="*.ts" --include="*.java" --include="*.c" \\
  --include="*.cpp" --include="*.sh" 2>/dev/null | head -20

echo ""
echo "Total found: $(grep -r "TODO\\|FIXME" . 2>/dev/null | wc -l)"`;

    this.saveCommand(name, code);
    console.log(`\n✨ Created: find-todos`);
    console.log(`📝 Finds all TODO and FIXME comments\n`);
  }

  createGenericCommand(input) {
    const name = this.generateCommandName(input);
    const code = `#!/bin/bash
# Generated from: ${input}

echo "🤖 Command '${name}' generated from:"
echo "   '${input}'"
echo ""
echo "📝 This is a placeholder. With Claude API key set,"
echo "   this would be a fully functional command."
echo ""
echo "✏️  Edit me at: ~/.port42-premise/bin/${name}"`;

    this.saveCommand(name, code);
    console.log(`\n✨ Created: ${name}`);
    console.log(`📝 A starting point for your idea\n`);
  }

  saveCommand(name, code) {
    const cmdPath = path.join(PORT42_HOME, 'bin', name);
    fs.writeFileSync(cmdPath, code);
    fs.chmodSync(cmdPath, '755');
    
    this.logCommand(name, 'Created via possession');
  }

  logCommand(name, source) {
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
      generatedBy: this.entity,
      powered_by: this.apiKey ? 'claude' : 'patterns',
      source
    });
    
    fs.writeFileSync(memoryFile, JSON.stringify(memory, null, 2));
  }
}

const possession = new ClaudePossession();
possession.start();
EOF

# Create the IMPROVED rule watcher with better logging
cat > ~/.port42-premise/lib/rule-watcher.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

console.log('👁️ Improved Rule Watcher v0.3 started');
console.log('   Checking rules every 10 seconds with detailed logging...\n');

// Check rules every 10 seconds
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
      
      // Check count-based rules
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
        
      // Check pattern-based rules  
      } else if (rule.when?.type === 'pattern') {
        const pattern = rule.when.pattern || '';
        const threshold = rule.when.threshold || 1;
        
        const matches = memory.commands?.filter(c => 
          c.name.toLowerCase().includes(pattern.toLowerCase())) || [];
        
        console.log(`      Pattern '${pattern}': ${matches.length}/${threshold} matches`);
        shouldTrigger = matches.length >= threshold;
        
      // Check combination rules
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
EOF

# Create debug rules helper
cat > ~/.port42-premise/lib/debug-rules.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

console.log('🔍 Debug Rules - Analyzing current state\n');

function debugRules() {
  const rulesFile = path.join(PORT42_HOME, 'memory', 'rules.json');
  const memoryFile = path.join(PORT42_HOME, 'memory', 'commands.json');
  
  console.log('📍 Files:');
  console.log(`   Rules: ${rulesFile}`);
  console.log(`   Memory: ${memoryFile}\n`);
  
  if (!fs.existsSync(rulesFile)) {
    console.log('❌ No rules.json file found');
    return;
  }
  
  if (!fs.existsSync(memoryFile)) {
    console.log('❌ No commands.json file found');  
    return;
  }
  
  try {
    const rules = JSON.parse(fs.readFileSync(rulesFile));
    const memory = JSON.parse(fs.readFileSync(memoryFile));
    
    console.log(`📊 Found ${rules.length} rules and ${memory.commands?.length || 0} commands\n`);
    
    rules.forEach((rule, index) => {
      console.log(`🔍 Rule ${index + 1}: "${rule.description}"`);
      console.log(`   Type: ${rule.when?.type || 'undefined'}`);
      console.log(`   Executed: ${rule.executed || false}`);
      
      if (rule.when?.type === 'pattern') {
        const matches = memory.commands?.filter(c => 
          c.name.includes(rule.when.pattern)) || [];
        console.log(`   Pattern matches: ${matches.length}`);
        matches.forEach(cmd => console.log(`     - ${cmd.name}`));
      }
      
      console.log('');
    });
    
  } catch (e) {
    console.error('❌ Error:', e.message);
  }
}

debugRules();
EOF

# Make everything executable
chmod +x ~/.port42-premise/port42-premise
chmod +x ~/.port42-premise/lib/possess-claude.js
chmod +x ~/.port42-premise/lib/rule-watcher.js
chmod +x ~/.port42-premise/lib/debug-rules.js

# Add to PATH (detect shell)
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# Add to shell config if not already there
if ! grep -q "port42-premise" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# Port 42 Premise v0.3 (Fixed command naming)" >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/.port42-premise/bin:\$PATH\"" >> "$SHELL_RC"
    echo "alias port42-premise=\"\$HOME/.port42-premise/port42-premise\"" >> "$SHELL_RC"
fi

echo "✅ Port 42 Premise v0.3 installed with fixed command naming!"
echo ""
echo "🔑 To enable Claude intelligence:"
echo "   export ANTHROPIC_API_KEY='your-api-key-here'"
echo ""
echo "🚀 Quick start:"
echo "   1. Run: source $SHELL_RC"
echo "   2. Run: port42-premise init"
echo "   3. Run: port42-premise possess claude"
echo ""
echo "🎯 NEW: Try exact command names:"
echo "   'create a command called echo-nicer that echoes nicely'"
echo "   'make something called my-tool that does X'"
echo ""
echo "👁️ Debug tools:"
echo "   port42-premise debug    # See current rules state"
echo "   port42-premise watch    # Monitor with better logging"
echo ""
echo "🐬 The dolphins approve of this precision naming..."
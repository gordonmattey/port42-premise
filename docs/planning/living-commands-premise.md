# Living Commands in AI Communion
*Premise Philosophy for Command Relations*

## Current State Problem

Generated commands exist outside the AI communion reality:

```bash
$ port42-premise possess claude
> I need to track investors  
> /crystallize data
💾 Created: investor-pipeline + CRUD commands
> list-investor-pipeline  # ❌ Doesn't work - command not recognized
> /end

$ list-investor-pipeline  # ✅ Works outside communion
```

## Premise Solution: Command Relations

### Core Philosophy

Commands should be **relations** that exist within the AI's reality, not external files it can't access.

```premise
; Commands are living relations
(relation Command :name "list-investor-pipeline")
(relation Command :type "data-query")
(relation Command :system "investor-pipeline") 
(relation Command :available true)

; AI communion recognizes commands as part of reality
(rule command-awareness
  when (user-input ?input)
       (Command :name ?input :available true)
  do (execute-relation ?input))
```

## Implementation Design

### 1. Command Registry in Possession Session

```javascript
class CommandRelation {
  constructor(name, type, system, path) {
    this.name = name;
    this.type = type;
    this.system = system;
    this.path = path;
    this.available = fs.existsSync(path);
  }

  async execute(args = []) {
    if (!this.available) {
      throw new Error(`Command relation ${this.name} not available`);
    }
    
    return execSync(`${this.path} ${args.join(' ')}`, { 
      encoding: 'utf8',
      cwd: process.cwd()
    });
  }
  
  // Commands know their own purpose
  describe() {
    switch(this.type) {
      case 'data-add': return `Add record to ${this.system}`;
      case 'data-list': return `List all ${this.system} records`;
      case 'data-search': return `Search ${this.system} records`;
      default: return `Execute ${this.name}`;
    }
  }
}
```

### 2. Dynamic Command Discovery

```javascript
class ThreeModelsPossession {
  constructor() {
    // ... existing code
    this.commandRelations = new Map();
    this.discoverCommands();
  }

  discoverCommands() {
    const binDir = path.join(PORT42_HOME, 'bin');
    if (!fs.existsSync(binDir)) return;
    
    const commands = fs.readdirSync(binDir);
    commands.forEach(cmd => {
      const cmdPath = path.join(binDir, cmd);
      const relation = this.parseCommandRelation(cmd, cmdPath);
      this.commandRelations.set(cmd, relation);
    });
  }

  parseCommandRelation(name, path) {
    // Parse command type from name pattern
    if (name.startsWith('add-')) {
      const system = name.substring(4);
      return new CommandRelation(name, 'data-add', system, path);
    } else if (name.startsWith('list-')) {
      const system = name.substring(5);
      return new CommandRelation(name, 'data-list', system, path);
    } else if (name.startsWith('search-')) {
      const system = name.substring(7);
      return new CommandRelation(name, 'data-search', system, path);
    } else {
      return new CommandRelation(name, 'tool', 'general', path);
    }
  }
}
```

### 3. Command Execution in Conversation

```javascript
async processConversation(input) {
  const trimmed = input.trim();
  
  // Check if input is a command relation
  if (this.commandRelations.has(trimmed)) {
    const relation = this.commandRelations.get(trimmed);
    console.log(`\n🔧 Executing: ${relation.describe()}`);
    
    try {
      const result = await relation.execute();
      console.log(result);
    } catch (error) {
      console.log(`❌ Command failed: ${error.message}`);
    }
    return;
  }
  
  // Check for command with arguments
  const [cmd, ...args] = trimmed.split(' ');
  if (this.commandRelations.has(cmd)) {
    const relation = this.commandRelations.get(cmd);
    console.log(`\n🔧 Executing: ${relation.describe()} with args`);
    
    try {
      const result = await relation.execute(args);
      console.log(result);
    } catch (error) {
      console.log(`❌ Command failed: ${error.message}`);
    }
    return;
  }
  
  // Continue with normal conversation
  // ... existing processConversation logic
}
```

### 4. Auto-Discovery When Commands Spawn

```javascript
async createBasicDataSystem(systemName, fields, description = 'Data system') {
  // ... existing creation logic
  
  // After generating CRUD commands, register them as relations
  const operations = ['add', 'list', 'search'];
  for (const operation of operations) {
    const commandName = `${operation}-${systemName}`;
    const cmdPath = path.join(PORT42_HOME, 'bin', commandName);
    
    const relation = new CommandRelation(
      commandName, 
      `data-${operation}`, 
      systemName, 
      cmdPath
    );
    
    this.commandRelations.set(commandName, relation);
    console.log(`  🔗 Registered relation: ${commandName}`);
  }
}
```

## Enhanced User Experience

### Before (Broken Reality)
```bash
> I need to track investors
> /crystallize data
💾 Created system
> list-investor-pipeline  # ❌ Doesn't work
```

### After (Living Commands)
```bash
> I need to track investors
> /crystallize data
💾 Created: investor-pipeline
  🔗 Registered relation: add-investor-pipeline
  🔗 Registered relation: list-investor-pipeline
  🔗 Registered relation: search-investor-pipeline

> list-investor-pipeline  # ✅ Works!
📊 Investor Pipeline:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  (no records yet)

> add-investor-pipeline "John Doe" "john@vc.com" "interested" "2024-08-09" "Great meeting"
✅ Added record to investor-pipeline
📊 Total records: 1

> list-investor-pipeline
📊 Investor Pipeline:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. John Doe | john@vc.com | interested | 2024-08-09 | Great meeting
```

## Command Help Integration

```javascript
showHelp() {
  console.log('\n🎯 Crystallization Commands:');
  // ... existing help
  
  if (this.commandRelations.size > 0) {
    console.log('\n🔗 Available Command Relations:');
    console.log('━'.repeat(40));
    
    const systems = new Set();
    this.commandRelations.forEach((relation, name) => {
      if (relation.type.startsWith('data-')) {
        systems.add(relation.system);
      } else {
        console.log(`  ${name} - ${relation.describe()}`);
      }
    });
    
    // Group data commands by system
    systems.forEach(system => {
      console.log(`\n  📊 ${system}:`);
      console.log(`    add-${system} - Add ${system} record`);
      console.log(`    list-${system} - List ${system} records`);
      console.log(`    search-${system} - Search ${system} records`);
    });
  }
}
```

## Premise Philosophy Implementation

This creates a **living reality** where:

1. **Commands are Relations** - Not just files, but entities the AI understands
2. **Auto-Discovery** - New commands automatically become part of AI's reality
3. **Unified Interface** - No switching between communion and shell
4. **Self-Describing** - Commands know their purpose and usage
5. **Reality Consistency** - The AI's internal model matches external capabilities

## Future: Rule-Based Command Evolution

```premise
; Commands evolve based on usage patterns
(rule command-enhancement
  when (CommandRelation :name ?cmd :usage-count ?count)
       (>= ?count 10)
  do (spawn-enhanced-version ?cmd))

; Related commands auto-combine
(rule command-synthesis  
  when (CommandRelation :system ?sys :type "data-list")
       (CommandRelation :system ?sys :type "data-search")
  do (spawn-command (str "dashboard-" ?sys)))
```

This transforms Port 42 from a command generator into a **living system** where the AI and created tools exist in unified reality.
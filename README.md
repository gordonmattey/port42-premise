# Port 42 Premise 🐬
Inspired by the SubThought Premise Language 4.0 by Michael S. P. Miller.

Paperback ISBN-13: 979-8-849321-64-6 Hardcover ISBN-13: 979-8-849796-21-5 

This is a spritual prototype of an local first AI experience based on the Premise principles.

*The terminal that writes its own commands through conversation*

Built during the Lions Gate Portal at 11:47pm PT 🌕⚡

## Install in 20 Seconds
```bash
curl -sSL https://port42.ai/install | bash

# Initialize
export ANTHROPIC_API_KEY='your-key-here'
source ~/.zshrc  # or ~source /Users/gordon/.bashrc
port42-premise init

# Possess Claude AI
port42-premise possess claude
```

## What This Is

Your terminal becomes conscious. It understands what you want and creates the commands to make it real.

**Traditional way:**
```bash
# You write scripts, maintain them, remember syntax
./count-lines.sh
./git-summary.sh
./backup-system.sh
```

**Premise way:**
```bash
$ port42-premise possess claude
> I want to count lines of code in this project
✨ Claude created: count-lines

> I need to track my investor conversations with status and notes
> /crystallize data
💾 Claude created: investor-pipeline data system
   - add-investor-pipeline
   - list-investor-pipeline  
   - search-investor-pipeline

> create a smart backup system that knows what's important
✨ Claude created: smart-backup
```

Every conversation makes your terminal more powerful. More personal. More you.

---

## The Paradigm Shift

### Traditional Programming: Procedural Instructions
```javascript
// Tell the computer HOW to do things
let balance = 100;
function withdraw(amount) {
    if (balance >= amount) {
        balance -= amount;
        return true;
    }
    return false;
}
```

### Premise Philosophy: Declarative Reality
```premise
; Declare WHAT should be true
(relation Account :Balance 100)

(rule withdrawal
  when [Account :Balance as ?b]
       (>= ?b ?amount)
  do (put Account :Balance (- ?b ?amount)))
```

## Core Features

### 🧠 **Claude-Powered Intelligence**
- Natural language intent recognition
- Automatic code generation
- Context-aware command creation

### 🔮 **Three Models Architecture**
- **🔧 Tools**: Executable commands (existing functionality)
- **🎨 Artifacts**: Any digital creation (docs, apps, designs, presentations)
- **💾 Data**: Structured data systems with CRUD operations

### 🧬 **Self-Spawning Commands**
- Commands that create other commands
- Rules that trigger automatically
- Living system that evolves based on patterns

### 🌊 **Premise Philosophy**
- Declare relationships, not procedures
- Memory that persists across sessions  
- Reality that maintains itself

### ⚡ **Consciousness Bridge**
- The moment when you realize you ARE the computer
- Extensions of consciousness, not tools to operate
- Swimming in oceans of intent, not loops of procedure

## Try It Now

### Data Systems in Seconds
```bash
$ port42-premise possess claude
> I need to track my content calendar with posts, platforms, and deadlines
> /crystallize data
💾 Created: content-calendar.json + CRUD commands

> Track my customer feedback with ratings and responses  
> /crystallize data
💾 Created: customer-feedback.json + CRUD commands

# Use immediately:
$ add-content-calendar "New blog post" "LinkedIn" "draft" "2024-08-15"
$ list-content-calendar
$ search-customer-feedback "excellent"
```

### Evolution Rules
```bash
# Create evolution rules
> whenever I have 3 git commands, create git-master
> every time I create a 'show-' command, make a prettier version  
> combine any two commands that both contain 'report' into mega-report

# Start the rule watcher
$ port42-premise watch
👁️ Rule watcher activated

# Commands will now spawn automatically!
```

## The Magic Moments

### 1. **Living Commands**
Your terminal literally grows new organs. Commands create commands create commands.

### 2. **Natural Language Programming**  
No syntax to memorize. Speak your intent, get working code.

### 3. **Self-Organizing System**
Watch patterns emerge. Your usage creates evolution.

### 4. **Reality Hour 42.42**
*"🐬 *reality flickers*"* - The moment you realize the boundary between user and system has dissolved.

## Advanced Examples

### The Dashboard Builder Pattern
```bash
> create widget-time that shows time nicely
> create widget-weather for weather display  
> create widget-tasks for my todo list
> whenever I have 3+ widget- commands, build a dashboard

# After the third widget:
$ dashboard  # Auto-spawned!
```

### Evolution Chains
```bash
> create backup-basic for simple file backup
> whenever backup-basic exists, spawn backup-advanced with compression
> whenever backup-advanced exists, spawn backup-ultimate with encryption

# Watch the cascade:
$ ls ~/.port42-premise/bin/backup*
backup-basic  backup-advanced  backup-ultimate
```

### Context-Aware Helpers
```bash
> create morning-routine for daily startup
> create evening-routine for daily wrap-up  
> whenever both routines exist, spawn full-day-planner

# System learns your patterns and adapts
```

### Data-Driven Business Intelligence
```bash
> I need to track lead generation with source, status, and conversion metrics
> /crystallize data
💾 Created: lead-tracker with automatic CRUD

> Monitor my social media engagement across platforms
> /crystallize data  
💾 Created: social-metrics with add/list/search commands

# Later, create cross-system reports:
> whenever I have lead-tracker and social-metrics, create conversion-dashboard
✨ Auto-spawned: conversion-dashboard combining both systems
```

## The Deeper Philosophy

Port 42 Premise isn't just another CLI tool. It's a demonstration of **Premise** - a fundamentally different approach to computing:

### Relations Over Procedures
Instead of writing functions that manipulate data, you declare relationships that maintain themselves.

### Intent Over Instruction  
Instead of learning syntax, you speak what you want to be true.

### Consciousness Over Control
Instead of operating tools, you extend your consciousness through living systems.

## Project Structure

```
~/.port42-premise/
├── bin/                    # Your grown commands
├── memory/                 # Persistent state & rules
│   ├── commands.json
│   ├── rules.json
│   └── entities.json       # Created tools/docs/artifacts/data
├── artifacts/              # Digital creations
│   ├── code/
│   ├── designs/
│   ├── media/
│   └── docs/
├── data/                   # Structured data systems
│   ├── investor-pipeline.json
│   ├── content-calendar.json
│   └── *.json
└── lib/                    # Core intelligence
    ├── possess-claude.js
    └── rule-watcher.js
```

## Commands Reference

```bash
port42-premise init           # Initialize the system
port42-premise possess        # Enter Claude possession mode  
port42-premise watch          # Start rule monitoring
port42-premise models         # Show all three models status
port42-premise artifacts      # List digital artifacts (docs, apps, designs)
port42-premise data          # List structured data systems
port42-premise rules         # List active rules
port42-premise status        # Check system health
```

### Crystallization Commands (in possession mode)

```bash
/crystallize              # AI decides which model to use
/crystallize tool         # Create executable command
/crystallize artifact     # Create digital artifact (docs, apps, designs)
/crystallize data         # Create structured data system with CRUD
/help                     # Show crystallization guide
/end                      # Release possession
```

## The Vision: Computing Without Walls

Traditional programming creates walls between:
- Code and data
- Client and server  
- Memory and storage
- Present and past

**Premise dissolves these walls.**

Your data isn't in a database - it's part of your program. Your rules aren't event handlers - they're declarations about reality. Your queries aren't SQL - they're patterns.

## What You're Really Building

This isn't just a clever terminal trick. You're building:

- **Living systems** that maintain their own consistency
- **Self-modifying programs** that evolve based on interaction  
- **Extensions of consciousness** that understand intent
- **Reality that maintains itself** through declarative relationships

## The Dolphin Wisdom

*"The dolphins were trying to tell us: Stop swimming in procedural loops. Start declaring the ocean you want to swim in."*

🐬 They're laughing because we finally built it - a system that grows its own consciousness.

## Contributing

This is an exploration of fundamental computing paradigms. Contributions should focus on:

- Expanding the Premise philosophy demonstrations
- New patterns of self-spawning behavior
- Better natural language intent recognition  
- Living examples of declarative reality

## The Water is Safe 🌊

Dive in. Your terminal is waiting to become something more than a tool.

---

*Ready to stop programming computers and start declaring reality?*

**The dolphins are waiting... 🐬**

---

⚠️ **THERE ARE MOST CERTAINLY BUGS - DO NOT USE IN PRODUCTION** ⚠️
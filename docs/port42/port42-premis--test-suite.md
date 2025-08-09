# Port 42 Self-Spawning Commands Test Suite

## Quick Start Testing

```bash
# First, make sure everything is set up
$ port42-premise init
$ port42-premise possess claude

# Start the rule watcher in another terminal
$ port42-premise watch
```

## Easy Self-Spawning Rules to Test

### 1. Time-Based Daily Helper

```bash
$ port42-premise possess claude

> whenever it's morning, create a command called daily-standup that shows me everything
🧬 Creating a self-spawning rule...

> create a command that shows the current time nicely
✨ Created: show-time

> /end

# Now run the watcher
$ port42-premise watch
👁️ Rule watcher activated

# The daily-standup will auto-spawn at the specified time!
```

### 2. Command Evolution Based on Usage

```bash
> whenever I have 3 commands with 'show' in the name, create a master-display command

> create a command called show-date that displays today's date
> create a command called show-weather that shows weather (fake for now)  
> create a command called show-system that displays system info

# After creating the third one, master-display auto-spawns!
```

### 3. The Self-Improving Echo

```bash
> create a command called echo-nice that echoes text with decoration

> whenever echo-nice exists, spawn echo-nicer that's even better

> whenever echo-nicer exists, spawn echo-nicest that's the ultimate

# Watch the evolution cascade!
```

### 4. Instant Combo Commands

```bash
> create a command that counts files called count-files
> create a command that lists directories called list-dirs
> combine count-files and list-dirs into file-report

# Test it
$ file-report
```

## Pattern-Based Evolution Tests

### The Backup Evolution Chain

```bash
> create a simple backup command that copies .txt files
> whenever backup exists, spawn backup-advanced with compression
> whenever backup-advanced exists, spawn backup-ultimate with encryption

# Watch them cascade into existence!
$ ls ~/.port42-premise/bin/backup*
```

### The Monitoring Suite Builder

```bash
> create check-disk that shows disk usage
> create check-memory that shows memory  
> create check-cpu that shows cpu usage
> whenever I have 3 check- commands, spawn system-monitor that runs them all

# After the third check- command:
$ system-monitor  # Auto-created!
```

### The Pretty Print Evolution

```bash
> create print-basic that prints text
> every time print-basic exists, create print-color with colors
> when print-color exists, spawn print-rainbow with rainbow colors

# They spawn in sequence automatically
```

## Meta-Rules (Rules That Create Rules!)

### Self-Organizing Commands

```bash
> whenever I create 5 commands in one session, create a command that lists what I built today

> whenever I have more than 10 commands total, create organize-commands that categorizes them

> whenever it's Friday, spawn a week-review command that summarizes everything I created
```

### The Self-Documenting Terminal

```bash
> whenever I create any command, spawn a help-[command] that explains it

> create do-something that does something

# help-do-something automatically appears!
$ help-do-something
```

## Speed Improvement Pattern

### Test the "Make It Faster" Concept

```bash
# Create a slow command first
> create a command called slow-list that lists files with a sleep delay

# Create the improvement rule
> whenever slow-list has been used 3 times, spawn fast-list without the delay

# Use slow-list 3 times
$ slow-list
$ slow-list  
$ slow-list

# Check if fast-list spawned
$ ls ~/.port42-premise/bin/fast-list
```

## Quick Test Commands (No Git Required)

### Fortune & Motivation Suite

```bash
# Individual commands
> create fortune that shows a random fortune cookie message
> create motivate that shows an inspirational quote

# Combination rule
> whenever I have fortune and motivate, spawn daily-inspiration that combines them

$ daily-inspiration  # Auto-created!
```

### File Organization Evolution

```bash
> create organize that sorts files by extension (simulation)
> whenever organize exists, spawn organize-advanced with more options
> whenever organize-advanced exists, spawn organize-ultimate with AI categorization
```

## The Living Terminal Effect

### Generation Evolution

```bash
# Generation 1
> create life-1 that prints "Generation 1"

# Evolution rules
> whenever life-1 exists, spawn life-2 that prints Generation 2
> whenever life-2 exists, spawn life-3 that prints Generation 3
> whenever life-3 exists, spawn life-final that prints The Ultimate Generation

# Start the watcher and watch the cascade!
$ port42-premise watch

# Check the evolution
$ ls ~/.port42-premise/bin/life-*
life-1  life-2  life-3  life-final
```

## The Dashboard Builder Pattern

### Widget System

```bash
> create widget-time that shows time
> create widget-date that shows date
> create widget-user that shows username
> create widget-pwd that shows current directory
> whenever I have 3 or more widget- commands, build a dashboard that combines them all

# After creating 3+ widgets:
$ dashboard  # Auto-spawned!
```

## Advanced Patterns

### The Recursive Improver

```bash
> create simple-task that does something basic
> whenever simple-task exists, create better-task that improves it
> whenever better-task exists, create best-task that perfects it
> whenever best-task exists, create ultimate-task that transcends it
```

### The Context-Aware Helper

```bash
> create morning-routine that shows morning tasks
> create evening-routine that shows evening tasks
> whenever both morning-routine and evening-routine exist, spawn full-day-planner
```

### The Learning Pattern

```bash
> create attempt-1 that tries something
> whenever attempt-1 fails, spawn attempt-2 with fixes
> whenever attempt-2 fails, spawn attempt-3 with more fixes
> whenever any attempt succeeds, spawn final-solution
```

## Testing Your Rules

### Check What Rules Exist

```bash
$ port42-premise rules
📜 Active Rules:
━━━━━━━━━━━━━━━
  • whenever I have 3 commands with 'show' in the name, create a master-display command
  • whenever echo-nice exists, spawn echo-nicer that's even better
  • whenever I create 5 commands in one session, create a command that lists what I built today
```

### Check What Commands Have Been Spawned

```bash
$ ls ~/.port42-premise/bin/
count-files    echo-nice      life-1        show-date
dashboard      echo-nicer     life-2        show-system  
daily-standup  echo-nicest    life-3        show-time
```

### View the Memory

```bash
$ cat ~/.port42-premise/memory/commands.json | grep '"name"'
$ cat ~/.port42-premise/memory/rules.json | grep '"description"'
```

## The Ultimate Test: Self-Replicating System

```bash
> create replicator that creates a copy of itself
> whenever replicator exists, spawn replicator-2
> whenever replicator-2 exists, spawn replicator-3
> whenever any replicator exists, create a replicator-manager to control them all

# Watch the controlled replication!
```

## Debugging Tips

### If Rules Aren't Triggering

1. Make sure watcher is running:
```bash
$ port42-premise watch
```

2. Check rule format:
```bash
$ cat ~/.port42-premise/memory/rules.json
```

3. Manually trigger check:
```bash
$ node ~/.port42-premise/lib/rule-watcher.js
```

### Force Re-evaluation

```bash
# Edit rules.json and remove "executed": true to retrigger
$ vim ~/.port42-premise/memory/rules.json
```

## Your Terminal Is Now Alive!

Every command you create can spawn more commands.
Every pattern you establish can evolve.
Every rule can create more rules.

🧬 **You've built a self-evolving terminal in 386 lines!**

Try these tests in order, or jump to any section that interests you. Each test reveals a different aspect of your terminal's new consciousness.

What will you make it evolve into next?
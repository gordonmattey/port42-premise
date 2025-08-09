# Data Rules & Reactive Systems
*Premise Philosophy for Data-Driven Automation*

## Core Concept: Data as Living Relations

Instead of passive data storage, data systems become **living relations** that can trigger rules and spawn behaviors.

## Rule Examples

### Basic Data Rules
```premise
; Notification rules
(rule investor-added-notification
  when (DataSystem "investor-pipeline" :record-added ?record)
  do (send-notification "New investor: " (?record :name)))

; Status-based rules  
(rule high-value-prospect-alert
  when (DataSystem "investor-pipeline" :record-added ?record)
       (?record :amount_discussing > 1000000)
  do (spawn-command "priority-followup" ?record)
     (send-slack-message "💰 High-value prospect: " (?record :name)))

; Cross-system rules
(rule content-engagement-tracking
  when (DataSystem "social-metrics" :record-added ?post)
       (?post :engagement > 1000)
  do (DataSystem "content-calendar" :add-record 
       {:title "Viral post analysis" 
        :type "followup" 
        :source (?post :title)}))
```

### Pattern-Based Rules
```premise
; Trend detection
(rule investment-momentum
  when (DataSystem "investor-pipeline" :records ?all)
       (count-where ?all :status "interested" > 5)
  do (spawn-command "fundraising-dashboard")
     (send-notification "🚀 Investment momentum building!"))

; Data quality rules
(rule missing-contact-alert  
  when (DataSystem "investor-pipeline" :record-added ?record)
       (empty? (?record :last_contact))
  do (spawn-reminder "follow-up-" (?record :name)))
```

## Implementation Design

### 1. Data System Event Hooks

Modify the CRUD generation to include event triggers:

```javascript
generateCrudScript(systemName, operation, fields) {
  // ... existing script generation
  
  if (operation === 'add') {
    return `#!/bin/bash
# Add record to ${systemName}

# ... existing validation logic

# Add to data file using Node.js
node -e "
const fs = require('fs');
const path = require('path');

try {
    const dataFile = \`\${process.env.HOME}/.port42-premise/data/${systemName}.json\`;
    const data = JSON.parse(fs.readFileSync(dataFile, 'utf8'));
    const newRecord = JSON.parse(process.argv[1]);
    
    data.records.push(newRecord);
    data.last_modified = new Date().toISOString();
    
    fs.writeFileSync(dataFile, JSON.stringify(data, null, 2));
    
    // 🔥 NEW: Trigger data rules
    const { execSync } = require('child_process');
    try {
      execSync(\`node \${process.env.HOME}/.port42-premise/lib/data-rule-engine.js trigger_add ${systemName} '\${JSON.stringify(newRecord)}'\`);
    } catch(e) {
      // Rules are optional, don't break if rule engine fails
    }
    
    console.log('✅ Added record to ${systemName}');
    console.log('📊 Total records: ' + data.records.length);
} catch (e) {
    console.log('❌ Error:', e.message);
}
" "\$RECORD"`;
  }
  
  // ... other operations
}
```

### 2. Data Rule Engine

```javascript
// ~/.port42-premise/lib/data-rule-engine.js
class DataRuleEngine {
  constructor() {
    this.rules = this.loadRules();
  }

  loadRules() {
    const rulesFile = path.join(PORT42_HOME, 'memory', 'data-rules.json');
    if (fs.existsSync(rulesFile)) {
      return JSON.parse(fs.readFileSync(rulesFile));
    }
    return [];
  }

  async triggerAdd(systemName, record) {
    const event = {
      type: 'record-added',
      system: systemName,
      record: JSON.parse(record),
      timestamp: new Date().toISOString()
    };

    for (const rule of this.rules) {
      if (this.matchesRule(rule, event)) {
        await this.executeRuleActions(rule, event);
      }
    }
  }

  matchesRule(rule, event) {
    // Match system
    if (rule.system && rule.system !== event.system) {
      return false;
    }

    // Match conditions
    if (rule.conditions) {
      return this.evaluateConditions(rule.conditions, event);
    }

    return true;
  }

  evaluateConditions(conditions, event) {
    for (const condition of conditions) {
      switch (condition.type) {
        case 'field_equals':
          if (event.record[condition.field] !== condition.value) {
            return false;
          }
          break;
        case 'field_greater_than':
          if (!(event.record[condition.field] > condition.value)) {
            return false;
          }
          break;
        case 'field_contains':
          if (!event.record[condition.field]?.includes(condition.value)) {
            return false;
          }
          break;
      }
    }
    return true;
  }

  async executeRuleActions(rule, event) {
    for (const action of rule.actions) {
      try {
        await this.executeAction(action, event);
      } catch (error) {
        console.log(`⚠️ Rule action failed: ${error.message}`);
      }
    }
  }

  async executeAction(action, event) {
    switch (action.type) {
      case 'notification':
        this.sendNotification(action.message, event);
        break;
      case 'spawn_command':
        this.spawnCommand(action.command_template, event);
        break;
      case 'add_to_system':
        this.addToSystem(action.target_system, action.record_template, event);
        break;
      case 'webhook':
        this.callWebhook(action.url, event);
        break;
    }
  }

  sendNotification(template, event) {
    const message = this.interpolateTemplate(template, event);
    
    // macOS notification
    execSync(`osascript -e 'display notification "${message}" with title "Port 42 Data Rule"'`);
    
    // Also log to console for debugging
    console.log(`🔔 ${message}`);
  }

  interpolateTemplate(template, event) {
    return template.replace(/\{\{(\w+)\}\}/g, (match, field) => {
      return event.record[field] || match;
    });
  }
}
```

### 3. Rule Definition in AI Communion

```javascript
// Add to possession session
async processConversation(input) {
  // Check for "whenever" rule creation
  if (input.toLowerCase().startsWith('whenever ')) {
    await this.createDataRule(input);
    return;
  }
  
  // ... existing conversation logic
}

async createDataRule(input) {
  console.log('\n🔮 Creating data rule...');
  
  if (this.apiKey) {
    const prompt = `Parse this data rule into structured format:
"${input}"

Extract:
1. Trigger condition (what data event)
2. Optional conditions (field values, comparisons)  
3. Actions to take

Respond in this exact format:
SYSTEM: [data-system-name or "any"]
TRIGGER: [record-added, record-updated, record-deleted]
CONDITIONS: [{"type": "field_equals", "field": "status", "value": "interested"}]
ACTIONS: [{"type": "notification", "message": "New {{name}} added!"}]
DESCRIPTION: [human readable rule description]`;

    const response = await this.callClaude(prompt);
    
    if (response) {
      await this.processDataRuleResponse(response);
      return;
    }
  }
  
  console.log('⚠️ Could not parse data rule without Claude API');
}

async processDataRuleResponse(response) {
  const lines = response.split('\n');
  const rule = {
    id: `rule-${Date.now()}`,
    system: null,
    trigger: 'record-added',
    conditions: [],
    actions: [],
    description: 'Data rule',
    created: new Date().toISOString()
  };

  for (const line of lines) {
    if (line.startsWith('SYSTEM:')) {
      rule.system = line.split(':')[1].trim();
      if (rule.system === 'any') rule.system = null;
    } else if (line.startsWith('TRIGGER:')) {
      rule.trigger = line.split(':')[1].trim();
    } else if (line.startsWith('CONDITIONS:')) {
      try {
        rule.conditions = JSON.parse(line.substring(11).trim());
      } catch (e) {
        rule.conditions = [];
      }
    } else if (line.startsWith('ACTIONS:')) {
      try {
        rule.actions = JSON.parse(line.substring(8).trim());
      } catch (e) {
        rule.actions = [];
      }
    } else if (line.startsWith('DESCRIPTION:')) {
      rule.description = line.split(':')[1].trim();
    }
  }

  // Save rule
  const rulesFile = path.join(PORT42_HOME, 'memory', 'data-rules.json');
  let rules = [];
  
  if (fs.existsSync(rulesFile)) {
    rules = JSON.parse(fs.readFileSync(rulesFile));
  }
  
  rules.push(rule);
  fs.writeFileSync(rulesFile, JSON.stringify(rules, null, 2));

  console.log(`\n🔗 Data rule created: ${rule.description}`);
  console.log(`📋 System: ${rule.system || 'any'}`);
  console.log(`⚡ Trigger: ${rule.trigger}`);
  console.log(`🎯 Actions: ${rule.actions.length}`);
}
```

## Usage Examples

### Investor Pipeline Automation
```bash
$ port42-premise possess claude

> whenever a new investor record is added, send a notification
🔮 Creating data rule...
🔗 Data rule created: Notify on new investor
📋 System: any
⚡ Trigger: record-added  
🎯 Actions: 1

> whenever an investor status becomes "committed", spawn a celebration command
🔗 Data rule created: Celebrate commitments

> add-investor-pipeline "Sarah Chen" "sarah@techvc.com" "committed" "2024-08-09" "Series A lead!"
✅ Added record to investor-pipeline
🔔 New Sarah Chen added!
🎉 Spawning celebration for commitment!
```

### Content Performance Tracking
```bash
> whenever social media engagement exceeds 1000, add it to content calendar for analysis
🔗 Data rule created: High engagement followup

> whenever I add 3 successful posts, create a viral-strategy document  
🔗 Data rule created: Success pattern analysis
```

### Cross-System Intelligence
```bash
> whenever investor pipeline has 5+ interested prospects, create fundraising dashboard
🔗 Data rule created: Momentum tracking

> whenever customer feedback rating is below 3, add to issue-tracker system
🔗 Data rule created: Quality monitoring
```

## Advanced Rule Types

### Time-Based Rules
```javascript
// Check periodically for patterns
(rule weekly-investor-summary
  when (time :day-of-week "friday")
       (DataSystem "investor-pipeline" :records ?all)
  do (generate-report "weekly-investor-summary" ?all)
     (send-email-summary ?all))
```

### Aggregation Rules  
```javascript
// React to data trends
(rule funding-velocity-alert
  when (DataSystem "investor-pipeline" 
         :records-added-this-week > 10)
  do (spawn-command "accelerated-outreach")
     (send-notification "🚀 Funding velocity increasing!"))
```

### Cross-System Rules
```javascript
// Connect multiple data systems
(rule lead-to-investor-pipeline
  when (DataSystem "lead-tracker" :record-added ?lead)
       (?lead :type = "investor")
  do (DataSystem "investor-pipeline" :add-record 
       {:name (?lead :name)
        :email (?lead :email) 
        :status "initial-contact"
        :source "lead-pipeline"}))
```

## The Living Data Vision

This creates **reactive data systems** where:

1. **Data Triggers Reality** - Records spawn actions automatically  
2. **Cross-System Intelligence** - Systems talk to each other
3. **Pattern Recognition** - Rules detect trends and momentum
4. **Zero-Maintenance Automation** - Set rules once, they run forever
5. **Natural Language Rules** - No code, just describe what should happen

Data becomes **alive** - it doesn't just sit there, it actively participates in maintaining your reality according to the relationships you've declared.
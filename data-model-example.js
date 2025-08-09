// Example implementation for /crystallize data in v0.4

async crystallizeData() {
  console.log('💾 Creating STRUCTURED DATA SYSTEM...');
  
  if (!this.conversationContext.length) {
    console.log('❌ No conversation context for data system');
    return;
  }

  if (this.apiKey) {
    const prompt = `Based on this conversation, create a structured data system:

${this.conversationContext.map(c => `${c.role}: ${c.content}`).join('\n')}

Extract the data structure and generate:
1. System name (kebab-case)
2. JSON schema for the data
3. CRUD operations needed

Respond in this exact format:
SYSTEM_NAME: [name]
SCHEMA: {
  "fields": [
    {"name": "field1", "type": "string", "required": true},
    {"name": "field2", "type": "string", "required": false}
  ]
}
OPERATIONS: ["add", "list", "update", "delete", "search"]`;

    const response = await this.callClaude(prompt);
    
    if (response) {
      await this.processDataSystemResponse(response);
      return;
    }
  }
  
  console.log('❌ Could not create data system without Claude API');
}

async processDataSystemResponse(response) {
  const lines = response.split('\n');
  let systemName = `data-system-${Date.now()}`;
  let schema = { fields: [] };
  let operations = ['add', 'list', 'update', 'delete'];

  for (const line of lines) {
    if (line.startsWith('SYSTEM_NAME:')) {
      systemName = line.split(':')[1].trim();
    } else if (line.startsWith('SCHEMA:')) {
      try {
        const schemaStr = line.substring(7).trim();
        schema = JSON.parse(schemaStr);
      } catch (e) {
        console.log('⚠️ Could not parse schema, using default');
      }
    } else if (line.startsWith('OPERATIONS:')) {
      try {
        const opsStr = line.substring(11).trim();
        operations = JSON.parse(opsStr);
      } catch (e) {
        console.log('⚠️ Could not parse operations, using default');
      }
    }
  }

  // Create data file
  const dataFile = path.join(PORT42_HOME, 'data', `${systemName}.json`);
  const initialData = { 
    schema: schema,
    records: [],
    created: new Date().toISOString(),
    last_modified: new Date().toISOString()
  };
  
  fs.writeFileSync(dataFile, JSON.stringify(initialData, null, 2));

  // Generate CRUD commands
  const crudCommands = [];
  for (const operation of operations) {
    const commandName = `${operation}-${systemName.replace('-', '_')}`;
    const commandScript = this.generateCrudScript(systemName, operation, schema);
    
    const cmdPath = path.join(PORT42_HOME, 'bin', commandName);
    fs.writeFileSync(cmdPath, commandScript);
    fs.chmodSync(cmdPath, '755');
    
    crudCommands.push(commandName);
  }

  console.log(`\n💾 Data system created: ${systemName}`);
  console.log(`📁 Data file: ${dataFile}`);
  console.log(`🔧 CRUD commands generated:`);
  crudCommands.forEach(cmd => console.log(`  - ${cmd}`));
  
  // Log to memory
  this.logEntity('data_system', systemName, dataFile);
}

generateCrudScript(systemName, operation, schema) {
  const dataFile = `~/.port42-premise/data/${systemName}.json`;
  
  switch (operation) {
    case 'add':
      return `#!/bin/bash
# Add record to ${systemName}

if [ $# -lt ${schema.fields.filter(f => f.required).length} ]; then
    echo "Usage: $0 ${schema.fields.map(f => f.required ? `<${f.name}>` : `[${f.name}]`).join(' ')}"
    exit 1
fi

# Create new record JSON
RECORD="{\\"timestamp\\": \\"$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)\\""
${schema.fields.map((f, i) => `RECORD="$RECORD, \\"${f.name}\\": \\"$${i+1}\\""`).join('\n')}
RECORD="$RECORD}"

# Add to data file
python3 -c "
import json
import sys

try:
    with open('${dataFile}', 'r') as f:
        data = json.load(f)
    
    new_record = json.loads(sys.argv[1])
    data['records'].append(new_record)
    data['last_modified'] = '$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)'
    
    with open('${dataFile}', 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f'✅ Added record to ${systemName}')
    print(f'📊 Total records: {len(data[\"records\"])}')
except Exception as e:
    print(f'❌ Error: {e}')
" "$RECORD"`;

    case 'list':
      return `#!/bin/bash
# List records from ${systemName}

python3 -c "
import json

try:
    with open('${dataFile}', 'r') as f:
        data = json.load(f)
    
    print(f'📊 ${systemName.replace('-', ' ').title()}:')
    print('━' * 30)
    
    if not data['records']:
        print('  (no records yet)')
    else:
        for i, record in enumerate(data['records'], 1):
            print(f'  {i}. ${schema.fields.map(f => `{record.get(\"${f.name}\", \"N/A\")}`).join(' | ')}')
        print(f'\\n📈 Total: {len(data[\"records\"])} records')
        
except Exception as e:
    print(f'❌ Error: {e}')
"`;

    case 'search':
      return `#!/bin/bash
# Search records in ${systemName}

if [ $# -lt 1 ]; then
    echo "Usage: $0 <search_term>"
    exit 1
fi

SEARCH_TERM="$1"

python3 -c "
import json
import sys

try:
    with open('${dataFile}', 'r') as f:
        data = json.load(f)
    
    search_term = sys.argv[1].lower()
    matches = []
    
    for record in data['records']:
        # Search all string fields
        for key, value in record.items():
            if isinstance(value, str) and search_term in value.lower():
                matches.append(record)
                break
    
    print(f'🔍 Search results for \"{search_term}\" in ${systemName}:')
    print('━' * 40)
    
    if not matches:
        print('  (no matches found)')
    else:
        for i, record in enumerate(matches, 1):
            print(f'  {i}. ${schema.fields.map(f => `{record.get(\"${f.name}\", \"N/A\")}`).join(' | ')}')
        print(f'\\n📋 Found {len(matches)} matches')
        
except Exception as e:
    print(f'❌ Error: {e}')
" "$SEARCH_TERM"`;

    default:
      return `#!/bin/bash
echo "🚧 ${operation} operation for ${systemName} not implemented yet"`;
  }
}

// Example conversation flows:

/*
INVESTOR TRACKING:
> I need to track investor conversations
> Each investor should have: name, email, status, last contact date, and notes
> /crystallize data

Creates:
- investor-tracker.json (data file)
- add-investor-tracker (command)
- list-investor-tracker (command)
- search-investor-tracker (command)

CONTENT CALENDAR:
> Help me manage my content calendar
> Each post needs: title, platform, status, publish date, engagement metrics
> /crystallize data  

Creates:
- content-calendar.json
- add-content-calendar, list-content-calendar, etc.

FEATURE REQUESTS:
> I want to track feature requests from users
> Fields: user, feature description, priority, status, date requested
> /crystallize data

Creates:
- feature-requests.json  
- add-feature-requests, list-feature-requests, etc.
*/
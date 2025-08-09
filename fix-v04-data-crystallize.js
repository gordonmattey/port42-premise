// Fix for v0.4 - Add missing /crystallize data functionality
// Replace the handleCrystallize method and add crystallizeData method

// In possess-claude.js, replace this section:

async handleCrystallize(command) {
  const parts = command.split(' ');
  const modelType = parts[1] || 'auto';
  
  console.log(`\n🔮 Crystallizing as ${modelType.toUpperCase()}...`);
  
  switch (modelType) {
    case 'auto':
      await this.autoCrystallize();
      break;
    case 'tool':
      await this.crystallizeTool();
      break;
    case 'document':
      await this.crystallizeDocument();
      break;
    case 'artifact':
      await this.crystallizeArtifact();
      break;
    case 'data':  // ADD THIS LINE
      await this.crystallizeData();  // ADD THIS LINE
      break;
    default:
      console.log('❌ Unknown crystallization type. Use: tool, document, artifact, data, or auto');
  }
}

// ADD THIS METHOD after crystallizeArtifact():

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
1. System name (kebab-case, no spaces)
2. JSON schema for the data
3. Fields that should be tracked

Respond in this exact format:
SYSTEM_NAME: [name]
FIELDS: ["field1", "field2", "field3"]
DESCRIPTION: [what this tracks]`;

    const response = await this.callClaude(prompt);
    
    if (response) {
      await this.processDataSystemResponse(response);
      return;
    }
  }
  
  // Fallback without Claude
  const topic = this.extractTopic();
  const systemName = `${topic}-data`;
  await this.createBasicDataSystem(systemName, ['name', 'status', 'notes', 'date']);
}

async processDataSystemResponse(response) {
  const lines = response.split('\n');
  let systemName = `data-system-${Date.now()}`;
  let fields = ['name', 'status', 'notes'];
  let description = 'Data tracking system';

  for (const line of lines) {
    if (line.startsWith('SYSTEM_NAME:')) {
      systemName = line.split(':')[1].trim().replace(/[^a-z0-9-]/gi, '-').toLowerCase();
    } else if (line.startsWith('FIELDS:')) {
      try {
        const fieldsStr = line.substring(7).trim();
        fields = JSON.parse(fieldsStr);
      } catch (e) {
        console.log('⚠️ Could not parse fields, using defaults');
      }
    } else if (line.startsWith('DESCRIPTION:')) {
      description = line.split(':')[1].trim();
    }
  }

  await this.createBasicDataSystem(systemName, fields, description);
}

async createBasicDataSystem(systemName, fields, description = 'Data system') {
  // Ensure data directory exists
  const dataDir = path.join(PORT42_HOME, 'data');
  if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
  }

  // Create data file
  const dataFile = path.join(dataDir, `${systemName}.json`);
  const initialData = { 
    system_name: systemName,
    description: description,
    fields: fields,
    records: [],
    created: new Date().toISOString(),
    last_modified: new Date().toISOString()
  };
  
  fs.writeFileSync(dataFile, JSON.stringify(initialData, null, 2));

  // Generate CRUD commands
  const crudCommands = [];
  const operations = ['add', 'list', 'search'];
  
  for (const operation of operations) {
    const commandName = `${operation}-${systemName}`;
    const commandScript = this.generateCrudScript(systemName, operation, fields);
    
    const cmdPath = path.join(PORT42_HOME, 'bin', commandName);
    fs.writeFileSync(cmdPath, commandScript);
    fs.chmodSync(cmdPath, '755');
    
    crudCommands.push(commandName);
  }

  console.log(`\n💾 Data system created: ${systemName}`);
  console.log(`📊 Description: ${description}`);
  console.log(`📁 Data file: ${dataFile}`);
  console.log(`🔧 CRUD commands generated:`);
  crudCommands.forEach(cmd => console.log(`  - ${cmd}`));
  
  console.log(`\n📝 Example usage:`);
  console.log(`  ${crudCommands[0]} ${fields.map(f => `"example_${f}"`).join(' ')}`);
  console.log(`  ${crudCommands[1]}`);
  console.log(`  ${crudCommands[2]} "search_term"`);
  
  // Log to memory
  this.logEntity('data_system', systemName, dataFile);
}

generateCrudScript(systemName, operation, fields) {
  const dataFile = `$HOME/.port42-premise/data/${systemName}.json`;
  
  switch (operation) {
    case 'add':
      return `#!/bin/bash
# Add record to ${systemName}

if [ $# -lt ${fields.length} ]; then
    echo "Usage: $0 ${fields.map(f => `<${f}>`).join(' ')}"
    echo "Example: $0 ${fields.map(f => `"example_${f}"`).join(' ')}"
    exit 1
fi

# Build JSON record
RECORD="{\\"timestamp\\": \\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\\""
${fields.map((f, i) => `RECORD="$RECORD, \\"${f}\\": \\"$${i+1}\\""`).join('\n')}
RECORD="$RECORD}"

# Add to data file using Node.js (more reliable than Python)
node -e "
const fs = require('fs');
const path = require('path');

try {
    const dataFile = '${dataFile}';
    const data = JSON.parse(fs.readFileSync(dataFile, 'utf8'));
    const newRecord = JSON.parse(process.argv[1]);
    
    data.records.push(newRecord);
    data.last_modified = new Date().toISOString();
    
    fs.writeFileSync(dataFile, JSON.stringify(data, null, 2));
    
    console.log('✅ Added record to ${systemName}');
    console.log('📊 Total records: ' + data.records.length);
} catch (e) {
    console.log('❌ Error:', e.message);
}
" "$RECORD"`;

    case 'list':
      return `#!/bin/bash
# List records from ${systemName}

node -e "
const fs = require('fs');

try {
    const dataFile = '${dataFile}';
    const data = JSON.parse(fs.readFileSync(dataFile, 'utf8'));
    
    console.log('📊 ' + data.system_name.replace(/-/g, ' ').replace(/\\b\\w/g, l => l.toUpperCase()) + ':');
    console.log('━'.repeat(40));
    
    if (data.records.length === 0) {
        console.log('  (no records yet)');
    } else {
        data.records.forEach((record, i) => {
            const fields = ${JSON.stringify(fields)};
            const values = fields.map(f => record[f] || 'N/A').join(' | ');
            console.log('  ' + (i + 1) + '. ' + values);
        });
        console.log('\\n📈 Total: ' + data.records.length + ' records');
    }
} catch (e) {
    console.log('❌ Error:', e.message);
}
"`;

    case 'search':
      return `#!/bin/bash
# Search records in ${systemName}

if [ $# -lt 1 ]; then
    echo "Usage: $0 <search_term>"
    exit 1
fi

SEARCH_TERM="$1"

node -e "
const fs = require('fs');

try {
    const dataFile = '${dataFile}';
    const data = JSON.parse(fs.readFileSync(dataFile, 'utf8'));
    const searchTerm = process.argv[1].toLowerCase();
    
    const matches = data.records.filter(record => {
        return Object.values(record).some(value => 
            String(value).toLowerCase().includes(searchTerm)
        );
    });
    
    console.log('🔍 Search results for \"' + searchTerm + '\" in ${systemName}:');
    console.log('━'.repeat(50));
    
    if (matches.length === 0) {
        console.log('  (no matches found)');
    } else {
        matches.forEach((record, i) => {
            const fields = ${JSON.stringify(fields)};
            const values = fields.map(f => record[f] || 'N/A').join(' | ');
            console.log('  ' + (i + 1) + '. ' + values);
        });
        console.log('\\n📋 Found ' + matches.length + ' matches');
    }
} catch (e) {
    console.log('❌ Error:', e.message);
}
" "$SEARCH_TERM"`;

    default:
      return `#!/bin/bash
echo "🚧 ${operation} operation for ${systemName} not implemented yet"`;
  }
}

// Also update the showHelp() method to include 'data':
showHelp() {
  console.log('\\n🎯 Crystallization Commands:');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('  /crystallize           - AI decides best model type');
  console.log('  /crystallize tool      - Create executable command');
  console.log('  /crystallize document  - Create/update knowledge document');
  console.log('  /crystallize artifact  - Create digital artifact');
  console.log('  /crystallize data      - Create structured data system');  // ADD THIS
  console.log('');
  console.log('🔧 TOOL Model: Executable commands for automation');
  console.log('📄 DOCUMENT Model: Living knowledge that evolves');
  console.log('🎨 ARTIFACT Model: Apps, designs, presentations, media');
  console.log('💾 DATA Model: Structured data with CRUD operations');  // ADD THIS
  console.log('');
}
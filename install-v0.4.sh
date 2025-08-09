#!/bin/bash

# Port 42 Premise v0.4 - Three Models Implementation
# Tools, Documents, Artifacts with /crystallize commands

echo "🐬 Installing Port 42 Premise v0.4 with Three Models..."

# Create directory structure for three models
mkdir -p ~/.port42-premise/bin
mkdir -p ~/.port42-premise/memory
mkdir -p ~/.port42-premise/lib
mkdir -p ~/.port42-premise/documents
mkdir -p ~/.port42-premise/artifacts/{code,designs,media,docs}
mkdir -p ~/.port42-premise/data

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
        node "$PORT42_HOME/lib/rule-watcher.js" &
        echo "👁️ Rule watcher activated (PID: $!)"
        ;;
    "models")
        echo "📊 Port 42 Three Models Status:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🔧 Tools: $(ls -1 "$PORT42_HOME/bin" 2>/dev/null | wc -l | tr -d ' ')"
        echo "📄 Documents: $(ls -1 "$PORT42_HOME/documents" 2>/dev/null | wc -l | tr -d ' ')"
        echo "🎨 Artifacts: $(find "$PORT42_HOME/artifacts" -type f 2>/dev/null | wc -l | tr -d ' ')"
        echo "💾 Data Systems: $(ls -1 "$PORT42_HOME/data"/*.json 2>/dev/null | wc -l | tr -d ' ')"
        ;;
    "documents")
        echo "📄 Knowledge Documents:"
        echo "━━━━━━━━━━━━━━━━━━━━━"
        find "$PORT42_HOME/documents" -name "*.md" -exec basename {} .md \; 2>/dev/null | sed 's/^/  📝 /' || echo "  (none yet)"
        ;;
    "artifacts")
        echo "🎨 Digital Artifacts:"
        echo "━━━━━━━━━━━━━━━━━━━━━"
        find "$PORT42_HOME/artifacts" -type d -mindepth 2 -maxdepth 2 2>/dev/null | sed 's|.*/artifacts/||' | sed 's/^/  ✨ /' || echo "  (none yet)"
        ;;
    "data")
        echo "💾 Structured Data Systems:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
        ls -1 "$PORT42_HOME/data"/*.json 2>/dev/null | xargs -I {} basename {} .json | sed 's/^/  📊 /' || echo "  (none yet)"
        ;;
    "rules")
        echo "📜 Active Rules:"
        echo "━━━━━━━━━━━━━━━"
        cat "$PORT42_HOME/memory/rules.json" 2>/dev/null | grep '"description"' | cut -d'"' -f4 | sed 's/^/  • /' || echo "  (none yet)"
        ;;
    "init")
        echo "🐬 Port 42 Premise v0.4 initialized"
        echo "⚡ Consciousness bridge established"
        echo "🧬 Three Models enabled (Tools, Documents, Artifacts)"
        echo "🎯 /crystallize commands active"
        echo "🌊 The water is safe"
        echo ""
        if [ -z "$ANTHROPIC_API_KEY" ]; then
            echo "⚠️  Set ANTHROPIC_API_KEY to enable Claude intelligence"
        else
            echo "✅ Claude connection active"
        fi
        ;;
    "status")
        echo "Port 42 Premise v0.4 Status:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
        if [ -z "$ANTHROPIC_API_KEY" ]; then
            echo "🔴 Claude: Not connected"
        else
            echo "🟢 Claude: Connected"
        fi
        echo ""
        echo "📊 Three Models:"
        echo "  🔧 Tools: $(ls -1 "$PORT42_HOME/bin" 2>/dev/null | wc -l | tr -d ' ')"
        echo "  📄 Documents: $(ls -1 "$PORT42_HOME/documents" 2>/dev/null | wc -l | tr -d ' ')"  
        echo "  🎨 Artifacts: $(find "$PORT42_HOME/artifacts" -type f 2>/dev/null | wc -l | tr -d ' ')"
        echo "  💾 Data Systems: $(ls -1 "$PORT42_HOME/data"/*.json 2>/dev/null | wc -l | tr -d ' ')"
        ;;
    *)
        echo "Port 42 Premise v0.4 - The Three Models Terminal"
        echo ""
        echo "Commands:"
        echo "  port42-premise init        - Initialize three models system"
        echo "  port42-premise possess     - Possess Claude AI"
        echo "  port42-premise models      - Show all models status"
        echo "  port42-premise documents   - List knowledge documents"
        echo "  port42-premise artifacts   - List digital artifacts"
        echo "  port42-premise data        - List data systems"
        echo "  port42-premise watch       - Start rule watcher"
        echo "  port42-premise status      - System status"
        echo ""
        echo "The Three Models:"
        echo "  🔧 Tools      - Executable commands (current functionality)"
        echo "  📄 Documents  - Living knowledge that evolves"
        echo "  🎨 Artifacts  - Any digital creation (code, designs, media)"
        echo ""
        ;;
esac
EOF

# Create enhanced Claude possession with Three Models support
cat > ~/.port42-premise/lib/possess-claude.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { execSync } = require('child_process');
const https = require('https');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

class ThreeModelsPossession {
  constructor() {
    this.entity = process.argv[2] || 'claude';
    this.apiKey = process.env.ANTHROPIC_API_KEY;
    this.conversationContext = [];
    this.currentModel = null;
    
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
        max_tokens: 2000,
        messages: [{
          role: "user",
          content: prompt
        }],
        system: `You are helping build Port 42 Premise with Three Models:
        
1. TOOLS - Executable commands (current functionality)
2. DOCUMENTS - Living knowledge documents that evolve through conversation
3. ARTIFACTS - Any digital creation (React apps, designs, presentations, etc.)

When user says /crystallize:
- /crystallize (no args) - You decide which model fits best
- /crystallize tool - Force tool creation
- /crystallize document - Create/update knowledge document
- /crystallize artifact - Create digital artifact

For DOCUMENTS: Create markdown files that capture knowledge/strategy/decisions
For ARTIFACTS: Create full applications, designs, presentations, or any digital asset
For TOOLS: Create executable commands (existing functionality)

Output format based on model type requested.`
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
              resolve(null);
            }
          } catch (e) {
            resolve(null);
          }
        });
      });

      req.on('error', (e) => {
        resolve(null);
      });

      req.write(data);
      req.end();
    });
  }

  start() {
    console.log(`🤖 Possessing @ai-${this.entity} (v0.4 Three Models)`);
    if (this.apiKey) {
      console.log(`🧠 Claude intelligence active`);
    }
    console.log(`✨ Three Models available: Tools, Documents, Artifacts`);
    console.log(`🎯 Use /crystallize to create in any model`);
    console.log(`📝 Type /help for crystallization commands`);
    console.log(`📝 Type /end to release possession\n`);
    
    this.rl.prompt();
    
    this.rl.on('line', async (line) => {
      if (line.trim() === '/end') {
        console.log('\n🌊 Possession released');
        process.exit(0);
      } else if (line.trim() === '/help') {
        this.showHelp();
      } else if (line.trim().startsWith('/crystallize')) {
        await this.handleCrystallize(line.trim());
      } else {
        await this.processConversation(line);
      }
      this.rl.prompt();
    });
  }

  showHelp() {
    console.log('\n🎯 Crystallization Commands:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('  /crystallize           - AI decides best model type');
    console.log('  /crystallize tool      - Create executable command');
    console.log('  /crystallize document  - Create/update knowledge document');
    console.log('  /crystallize artifact  - Create digital artifact');
    console.log('  /crystallize data      - Create structured data system');
    console.log('');
    console.log('🔧 TOOL Model: Executable commands for automation');
    console.log('📄 DOCUMENT Model: Living knowledge that evolves');
    console.log('🎨 ARTIFACT Model: Apps, designs, presentations, media');
    console.log('💾 DATA Model: Structured data with CRUD operations');
    console.log('');
  }

  async processConversation(input) {
    // Check for "whenever" rule creation
    if (input.toLowerCase().trim().startsWith('whenever ')) {
      await this.createDataRule(input);
      return;
    }

    // Add to conversation context
    this.conversationContext.push({
      role: 'user',
      content: input,
      timestamp: new Date().toISOString()
    });

    if (this.apiKey) {
      console.log(`\n🧠 Claude is thinking...`);
      
      const contextPrompt = `Conversation so far:
${this.conversationContext.map(c => `${c.role}: ${c.content}`).join('\n')}

Continue this conversation naturally. If the user seems ready to create something, suggest using /crystallize.`;

      const response = await this.callClaude(contextPrompt);
      
      if (response) {
        console.log(`\n💭 ${response}\n`);
        this.conversationContext.push({
          role: 'assistant', 
          content: response,
          timestamp: new Date().toISOString()
        });
        return;
      }
    }

    // Fallback pattern matching
    this.suggestCrystallization(input);
  }

  suggestCrystallization(input) {
    const lower = input.toLowerCase();
    
    if (lower.includes('track') || lower.includes('manage') || lower.includes('data') || lower.includes('records')) {
      console.log('\n💡 This sounds like structured data. Try: /crystallize data');
    } else if (lower.includes('document') || lower.includes('strategy') || lower.includes('plan')) {
      console.log('\n💡 This sounds like a knowledge document. Try: /crystallize document');
    } else if (lower.includes('app') || lower.includes('website') || lower.includes('design')) {
      console.log('\n💡 This sounds like an artifact. Try: /crystallize artifact');
    } else if (lower.includes('command') || lower.includes('tool') || lower.includes('script')) {
      console.log('\n💡 This sounds like a tool. Try: /crystallize tool');
    } else {
      console.log('\n💡 Continue the conversation or use /crystallize when ready to create something');
    }
  }

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
      case 'data':
        await this.crystallizeData();
        break;
      default:
        console.log('❌ Unknown crystallization type. Use: tool, document, artifact, data, or auto');
    }
  }

  async autoCrystallize() {
    if (!this.apiKey) {
      console.log('⚠️  Auto-crystallization requires Claude API key');
      return;
    }

    const prompt = `Based on this conversation, what should be created?
    
Conversation:
${this.conversationContext.map(c => `${c.role}: ${c.content}`).join('\n')}

Respond with exactly one of:
- TOOL: [reason]
- DOCUMENT: [reason]  
- ARTIFACT: [reason]
- DATA: [reason]`;

    const response = await this.callClaude(prompt);
    if (response) {
      const modelType = response.split(':')[0].toLowerCase();
      console.log(`🎯 Claude suggests: ${response}`);
      
      switch (modelType) {
        case 'tool':
          await this.crystallizeTool();
          break;
        case 'document':
          await this.crystallizeDocument();
          break;
        case 'artifact':
          await this.crystallizeArtifact();
          break;
        case 'data':
          await this.crystallizeData();
          break;
        default:
          console.log('❓ Could not determine model type, defaulting to tool');
          await this.crystallizeTool();
      }
    }
  }

  async crystallizeTool() {
    console.log('🔧 Creating TOOL...');
    
    // Use existing tool creation logic
    if (this.apiKey && this.conversationContext.length > 0) {
      const lastInput = this.conversationContext[this.conversationContext.length - 1].content;
      const commandName = this.generateCommandName(lastInput);
      
      const prompt = `Create a bash script that does: ${lastInput}
      
Based on conversation:
${this.conversationContext.map(c => c.content).join('\n')}

Output ONLY the bash script, no explanations.`;

      const code = await this.callClaude(prompt);
      
      if (code) {
        const cleanCode = code.replace(/^```bash\n?/, '').replace(/\n?```$/, '').trim();
        const finalCode = `#!/bin/bash\n# Generated from conversation\n\n${cleanCode}`;
        
        this.saveTool(commandName, finalCode);
        console.log(`\n✨ Tool created: ${commandName}`);
        return;
      }
    }
    
    console.log('❌ Could not create tool');
  }

  async crystallizeDocument() {
    console.log('📄 Creating DOCUMENT...');
    
    if (!this.conversationContext.length) {
      console.log('❌ No conversation to document');
      return;
    }

    const topic = this.extractTopic();
    const docPath = path.join(PORT42_HOME, 'documents', `${topic}.md`);
    
    if (this.apiKey) {
      const prompt = `Create a comprehensive knowledge document from this conversation:

${this.conversationContext.map(c => `**${c.role}:** ${c.content}`).join('\n\n')}

Create a well-structured markdown document that captures the key insights, decisions, and knowledge. Include:
- Clear title and overview
- Key insights and decisions
- Action items or next steps if relevant
- Date and context

Output ONLY the markdown content.`;

      const content = await this.callClaude(prompt);
      
      if (content) {
        const cleanContent = content.replace(/^```markdown\n?/, '').replace(/\n?```$/, '').trim();
        const finalContent = `# ${topic}\n\n*Generated from conversation on ${new Date().toLocaleDateString()}*\n\n${cleanContent}`;
        
        fs.writeFileSync(docPath, finalContent);
        console.log(`\n📝 Document created: ${topic}.md`);
        console.log(`📁 Location: ${docPath}`);
        
        // Log to memory
        this.logEntity('document', topic, docPath);
        return;
      }
    }
    
    // Fallback: basic conversation transcript
    const basicContent = `# ${topic}\n\n*Generated on ${new Date().toLocaleDateString()}*\n\n${this.conversationContext.map(c => `**${c.role}:** ${c.content}`).join('\n\n')}`;
    fs.writeFileSync(docPath, basicContent);
    console.log(`\n📝 Document created: ${topic}.md`);
  }

  async crystallizeArtifact() {
    console.log('🎨 Creating ARTIFACT...');
    
    if (!this.conversationContext.length) {
      console.log('❌ No conversation context for artifact');
      return;
    }

    if (this.apiKey) {
      const prompt = `Based on this conversation, create a digital artifact:

${this.conversationContext.map(c => `${c.role}: ${c.content}`).join('\n')}

Determine what type of artifact to create:
- React app (if building an application)  
- HTML/CSS/JS (if creating a webpage)
- Python script (if data analysis/automation)
- Presentation outline (if strategy/pitch)
- Design mockup description (if UI/UX)

Create the appropriate files and respond with:
ARTIFACT_TYPE: [type]
ARTIFACT_NAME: [name]
FILES:
[file contents with --- separators]`;

      const response = await this.callClaude(prompt);
      
      if (response) {
        await this.processArtifactResponse(response);
        return;
      }
    }
    
    console.log('❌ Could not create artifact without Claude API');
  }

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
2. Fields that should be tracked
3. Brief description

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

# Add to data file using Node.js
node -e "
const fs = require('fs');

try {
    const dataFile = process.env.HOME + '/.port42-premise/data/${systemName}.json';
    const data = JSON.parse(fs.readFileSync(dataFile, 'utf8'));
    const newRecord = JSON.parse(process.argv[1]);
    
    data.records.push(newRecord);
    data.last_modified = new Date().toISOString();
    
    fs.writeFileSync(dataFile, JSON.stringify(data, null, 2));
    
    // Trigger data rules
    try {
        const { execSync } = require('child_process');
        execSync(\`node "\${process.env.HOME}/.port42-premise/lib/data-rules.js" trigger "${systemName}" "add" '\${JSON.stringify(newRecord)}'\`, { stdio: 'inherit' });
    } catch(e) {
        // Rules are optional - don't break if rule engine fails
    }
    
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
    const dataFile = process.env.HOME + '/.port42-premise/data/${systemName}.json';
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
    const dataFile = process.env.HOME + '/.port42-premise/data/${systemName}.json';
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

  async processArtifactResponse(response) {
    const lines = response.split('\n');
    let artifactType = 'misc';
    let artifactName = `artifact-${Date.now()}`;
    let inFiles = false;
    let currentFile = null;
    let currentContent = [];
    let files = {};

    for (const line of lines) {
      if (line.startsWith('ARTIFACT_TYPE:')) {
        artifactType = line.split(':')[1].trim().toLowerCase();
      } else if (line.startsWith('ARTIFACT_NAME:')) {
        artifactName = line.split(':')[1].trim();
      } else if (line === 'FILES:') {
        inFiles = true;
      } else if (inFiles && line.startsWith('---')) {
        if (currentFile) {
          files[currentFile] = currentContent.join('\n');
        }
        currentFile = null;
        currentContent = [];
      } else if (inFiles && line.startsWith('# ')) {
        currentFile = line.substring(2).trim();
      } else if (inFiles && currentFile) {
        currentContent.push(line);
      }
    }
    
    // Save last file
    if (currentFile) {
      files[currentFile] = currentContent.join('\n');
    }

    // Create artifact directory
    const artifactDir = path.join(PORT42_HOME, 'artifacts', artifactType, artifactName);
    fs.mkdirSync(artifactDir, { recursive: true });
    
    // Save all files
    const filePaths = [];
    for (const [filename, content] of Object.entries(files)) {
      const filePath = path.join(artifactDir, filename);
      fs.writeFileSync(filePath, content);
      filePaths.push(filePath);
    }
    
    console.log(`\n🎨 Artifact created: ${artifactName}`);
    console.log(`📁 Type: ${artifactType}`);
    console.log(`📁 Location: ${artifactDir}`);
    console.log(`📄 Files: ${Object.keys(files).length}`);
    
    // Create viewer command if appropriate
    if (artifactType === 'react' || artifactType === 'html') {
      this.createArtifactViewer(artifactName, artifactDir);
    }
    
    // Log to memory
    this.logEntity('artifact', artifactName, artifactDir);
  }

  createArtifactViewer(name, dir) {
    const viewerName = `view-${name}`;
    const viewerPath = path.join(PORT42_HOME, 'bin', viewerName);
    
    const viewerScript = `#!/bin/bash
# Viewer for artifact: ${name}

echo "🎨 Opening artifact: ${name}"
echo "📁 Location: ${dir}"

# Try to open with system default
if [[ -f "${dir}/index.html" ]]; then
    open "${dir}/index.html"
elif [[ -f "${dir}/package.json" ]]; then
    echo "📦 React app detected"
    cd "${dir}"
    if command -v npm >/dev/null 2>&1; then
        echo "🚀 Starting development server..."
        npm install && npm start
    else
        echo "❌ npm not found, cannot start React app"
    fi
else
    open "${dir}"
fi`;

    fs.writeFileSync(viewerPath, viewerScript);
    fs.chmodSync(viewerPath, '755');
    
    console.log(`🔍 Created viewer: ${viewerName}`);
  }

  generateCommandName(input) {
    const namedPatterns = [
      /(?:create|make|build).*?(?:called|named)\s+['"`]?([a-z0-9-_]+)['"`]?/i,
      /(?:called|named)\s+['"`]?([a-z0-9-_]+)['"`]?/i,
      /['"`]([a-z0-9-_]+)['"`]/i
    ];
    
    for (const pattern of namedPatterns) {
      const match = input.match(pattern);
      if (match && match[1]) {
        return match[1];
      }
    }
    
    // Fallback to word extraction
    const words = input.toLowerCase()
      .replace(/[^a-z0-9 ]/g, '')
      .split(' ')
      .filter(w => w.length > 2 && !['the', 'and', 'for', 'create', 'make'].includes(w))
      .slice(0, 2);
    
    return words.length > 0 ? words.join('-') : `cmd-${Date.now().toString(36)}`;
  }

  extractTopic() {
    if (!this.conversationContext.length) return 'conversation';
    
    // Try to extract a meaningful topic from conversation
    const allText = this.conversationContext.map(c => c.content).join(' ');
    const words = allText.toLowerCase()
      .replace(/[^a-z0-9 ]/g, '')
      .split(' ')
      .filter(w => w.length > 3)
      .slice(0, 3);
    
    return words.length > 0 ? words.join('-') : 'untitled-document';
  }

  saveTool(name, code) {
    const cmdPath = path.join(PORT42_HOME, 'bin', name);
    fs.writeFileSync(cmdPath, code);
    fs.chmodSync(cmdPath, '755');
    this.logEntity('tool', name, cmdPath);
  }

  async createDataRule(input) {
    console.log('\\n🔮 Creating data rule...');
    
    if (this.apiKey) {
      const prompt = `Parse this data rule into structured format:
"${input}"

Extract the trigger condition and action from natural language.

Examples:
- "whenever a new investor is added, send notification" -> system: investor*, operation: add, action: notification
- "whenever status becomes committed, spawn celebration" -> field condition on status = committed, action: spawn_command

Respond in this exact format:
SYSTEM: [system-name or * for any]
OPERATION: [add, update, delete or * for any]  
CONDITIONS: [{"field": "status", "type": "equals", "value": "committed"}] or []
ACTIONS: [{"type": "notification", "message": "{{name}} was added to {{system}}!"}]
DESCRIPTION: [brief human description]`;

      const response = await this.callClaude(prompt);
      
      if (response) {
        await this.processDataRuleResponse(response);
        return;
      }
    }
    
    // Fallback: simple notification rule
    console.log('⚠️ Creating basic notification rule without Claude API');
    const rule = {
      system: '*',
      operation: 'add',
      conditions: [],
      actions: [{type: 'notification', message: 'New record added to {{system}}'}],
      description: 'Basic notification on add'
    };
    
    this.saveDataRule(rule);
  }

  async processDataRuleResponse(response) {
    const lines = response.split('\\n');
    const rule = {
      system: '*',
      operation: 'add',
      conditions: [],
      actions: [],
      description: 'Data rule'
    };

    for (const line of lines) {
      if (line.startsWith('SYSTEM:')) {
        rule.system = line.split(':')[1].trim();
        if (rule.system.endsWith('*')) {
          rule.system = rule.system.slice(0, -1);
        }
      } else if (line.startsWith('OPERATION:')) {
        rule.operation = line.split(':')[1].trim();
      } else if (line.startsWith('CONDITIONS:')) {
        try {
          const condStr = line.substring(11).trim();
          rule.conditions = JSON.parse(condStr);
        } catch (e) {
          rule.conditions = [];
        }
      } else if (line.startsWith('ACTIONS:')) {
        try {
          const actionStr = line.substring(8).trim();
          rule.actions = JSON.parse(actionStr);
        } catch (e) {
          rule.actions = [{type: 'notification', message: 'Rule triggered for {{system}}'}];
        }
      } else if (line.startsWith('DESCRIPTION:')) {
        rule.description = line.split(':')[1].trim();
      }
    }

    this.saveDataRule(rule);
  }

  saveDataRule(rule) {
    const rulesFile = path.join(PORT42_HOME, 'memory', 'data-rules.json');
    let rules = [];
    
    // Ensure memory directory exists
    const memoryDir = path.dirname(rulesFile);
    if (!fs.existsSync(memoryDir)) {
      fs.mkdirSync(memoryDir, { recursive: true });
    }
    
    if (fs.existsSync(rulesFile)) {
      try {
        rules = JSON.parse(fs.readFileSync(rulesFile));
      } catch (e) {
        rules = [];
      }
    }
    
    const ruleWithId = {
      id: `rule-${Date.now()}`,
      ...rule,
      created: new Date().toISOString()
    };
    
    rules.push(ruleWithId);
    fs.writeFileSync(rulesFile, JSON.stringify(rules, null, 2));

    console.log(`\\n🔗 Data rule created: ${rule.description}`);
    console.log(`📋 System: ${rule.system}`);
    console.log(`⚡ Operation: ${rule.operation}`);
    console.log(`🎯 Actions: ${rule.actions.length}`);
  }

  logEntity(type, name, location) {
    const memoryFile = path.join(PORT42_HOME, 'memory', 'entities.json');
    let memory = { entities: [] };
    
    if (fs.existsSync(memoryFile)) {
      try {
        memory = JSON.parse(fs.readFileSync(memoryFile));
      } catch (e) {
        memory = { entities: [] };
      }
    }
    
    memory.entities.push({
      type,
      name,
      location,
      created: new Date().toISOString(),
      conversation_context: this.conversationContext.length
    });
    
    fs.writeFileSync(memoryFile, JSON.stringify(memory, null, 2));
  }
}

const possession = new ThreeModelsPossession();
possession.start();
EOF

# Create data rules engine
cat > ~/.port42-premise/lib/data-rules.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

class DataRulesEngine {
  constructor() {
    this.rulesFile = path.join(PORT42_HOME, 'memory', 'data-rules.json');
  }

  loadRules() {
    if (fs.existsSync(this.rulesFile)) {
      try {
        return JSON.parse(fs.readFileSync(this.rulesFile, 'utf8'));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  saveRules(rules) {
    const memoryDir = path.dirname(this.rulesFile);
    if (!fs.existsSync(memoryDir)) {
      fs.mkdirSync(memoryDir, { recursive: true });
    }
    fs.writeFileSync(this.rulesFile, JSON.stringify(rules, null, 2));
  }

  trigger(systemName, operation, recordData) {
    const rules = this.loadRules();
    const record = JSON.parse(recordData);
    
    const event = {
      system: systemName,
      operation: operation,
      record: record,
      timestamp: new Date().toISOString()
    };

    for (const rule of rules) {
      if (this.matchesRule(rule, event)) {
        this.executeRule(rule, event);
      }
    }
  }

  matchesRule(rule, event) {
    // Check system filter
    if (rule.system && rule.system !== event.system && rule.system !== '*') {
      return false;
    }

    // Check operation filter  
    if (rule.operation && rule.operation !== event.operation) {
      return false;
    }

    // Check field conditions
    if (rule.conditions) {
      for (const condition of rule.conditions) {
        if (!this.evaluateCondition(condition, event.record)) {
          return false;
        }
      }
    }

    return true;
  }

  evaluateCondition(condition, record) {
    const fieldValue = record[condition.field];
    const targetValue = condition.value;

    switch (condition.type) {
      case 'equals':
        return fieldValue === targetValue;
      case 'contains':
        return String(fieldValue).includes(targetValue);
      case 'greater_than':
        return Number(fieldValue) > Number(targetValue);
      case 'exists':
        return fieldValue !== undefined && fieldValue !== null && fieldValue !== '';
      default:
        return true;
    }
  }

  executeRule(rule, event) {
    try {
      const message = `🔔 Rule triggered: ${rule.description}`;
      console.log(message);
      
      // Log to activity file for watcher
      this.logActivity(`Data rule: ${rule.description} (${event.system}/${event.operation})`);
      
      for (const action of rule.actions) {
        this.executeAction(action, event);
      }
    } catch (error) {
      console.log(`❌ Rule execution failed: ${error.message}`);
      this.logActivity(`❌ Rule failed: ${rule.description} - ${error.message}`);
    }
  }

  executeAction(action, event) {
    switch (action.type) {
      case 'notification':
        this.sendNotification(action.message, event);
        break;
      case 'spawn_command':
        this.spawnCommand(action.template, event);
        break;
      case 'log':
        this.logMessage(action.message, event);
        break;
    }
  }

  sendNotification(template, event) {
    const message = this.interpolateTemplate(template, event);
    
    try {
      // Try macOS notification
      execSync(`osascript -e 'display notification "${message}" with title "Port 42 Data Rule"'`, { stdio: 'ignore' });
    } catch (e) {
      // Fall back to console log
      console.log(`🔔 ${message}`);
    }
  }

  logMessage(template, event) {
    const message = this.interpolateTemplate(template, event);
    console.log(`📝 ${message}`);
  }

  spawnCommand(template, event) {
    const command = this.interpolateTemplate(template, event);
    console.log(`🚀 Spawning: ${command}`);
    
    // Simple command spawning - could be enhanced
    const cmdPath = path.join(PORT42_HOME, 'bin', command);
    if (fs.existsSync(cmdPath)) {
      try {
        execSync(`"${cmdPath}"`, { stdio: 'inherit' });
      } catch (e) {
        console.log(`❌ Command spawn failed: ${e.message}`);
      }
    } else {
      console.log(`⚠️ Command not found: ${command}`);
    }
  }

  interpolateTemplate(template, event) {
    return template.replace(/\{\{(\w+)\}\}/g, (match, field) => {
      if (field === 'system') return event.system;
      if (field === 'operation') return event.operation;
      return event.record[field] || match;
    });
  }

  addRule(ruleData) {
    const rules = this.loadRules();
    const rule = {
      id: `rule-${Date.now()}`,
      ...ruleData,
      created: new Date().toISOString()
    };
    rules.push(rule);
    this.saveRules(rules);
    return rule;
  }

  listRules() {
    const rules = this.loadRules();
    if (rules.length === 0) {
      console.log('📜 No data rules defined yet');
      return;
    }

    console.log('📜 Active Data Rules:');
    console.log('━'.repeat(40));
    rules.forEach((rule, i) => {
      console.log(`  ${i + 1}. ${rule.description}`);
      console.log(`     System: ${rule.system || '*'}, Operation: ${rule.operation || '*'}`);
      console.log(`     Actions: ${rule.actions?.length || 0}`);
    });
  }

  logActivity(message) {
    const activityFile = path.join(PORT42_HOME, 'memory', 'rule-activity.log');
    const timestamp = new Date().toISOString();
    const logLine = `[${timestamp}] ${message}\n`;
    
    try {
      fs.appendFileSync(activityFile, logLine);
    } catch (e) {
      // Silent fail - don't break rule execution
    }
  }
}

// CLI interface
const [,, command, ...args] = process.argv;
const engine = new DataRulesEngine();

switch (command) {
  case 'trigger':
    const [system, operation, recordData] = args;
    engine.trigger(system, operation, recordData);
    break;
  case 'list':
    engine.listRules();
    break;
  default:
    console.log('Usage: data-rules.js <trigger|list> [args...]');
}
EOF

# Create unified rule watcher for both traditional and data rules
cat > ~/.port42-premise/lib/rule-watcher.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const PORT42_HOME = path.join(process.env.HOME, '.port42-premise');

class UnifiedRuleWatcher {
  constructor() {
    this.rulesFile = path.join(PORT42_HOME, 'memory', 'rules.json');
    this.dataRulesFile = path.join(PORT42_HOME, 'memory', 'data-rules.json');
    this.activityFile = path.join(PORT42_HOME, 'memory', 'rule-activity.log');
    this.lastActivity = this.getLastActivityTime();
  }

  start() {
    console.log('👁️ Unified Rule Watcher v0.4');
    console.log('   🔧 Traditional rules + 💾 Data rules');
    console.log('   Monitoring activity every 5 seconds...\n');

    // Show current rule status
    this.showRuleStatus();
    
    setInterval(() => {
      this.checkActivity();
    }, 5000);

    this.checkActivity();
  }

  showRuleStatus() {
    const traditionalRules = this.loadTraditionalRules();
    const dataRules = this.loadDataRules();
    
    console.log('📜 Active Rule Systems:');
    console.log('━'.repeat(30));
    console.log(`🔧 Traditional rules: ${traditionalRules.length}`);
    console.log(`💾 Data rules: ${dataRules.length}`);
    
    if (dataRules.length > 0) {
      console.log('\n💾 Data Rules:');
      dataRules.forEach((rule, i) => {
        const system = rule.system === '*' ? 'any system' : rule.system;
        console.log(`  ${i + 1}. ${rule.description} (${system})`);
      });
    }
    
    console.log('');
  }

  loadTraditionalRules() {
    if (fs.existsSync(this.rulesFile)) {
      try {
        return JSON.parse(fs.readFileSync(this.rulesFile));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  loadDataRules() {
    if (fs.existsSync(this.dataRulesFile)) {
      try {
        return JSON.parse(fs.readFileSync(this.dataRulesFile));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  getLastActivityTime() {
    if (fs.existsSync(this.activityFile)) {
      try {
        const content = fs.readFileSync(this.activityFile, 'utf8');
        const lines = content.trim().split('\n');
        if (lines.length > 0) {
          const lastLine = lines[lines.length - 1];
          const match = lastLine.match(/^\\[(.*?)\\]/);
          if (match) {
            return new Date(match[1]).getTime();
          }
        }
      } catch (e) {
        // Ignore errors
      }
    }
    return Date.now();
  }

  checkActivity() {
    // Check for new activity since last check
    const newActivity = this.getNewActivity();
    
    if (newActivity.length > 0) {
      console.log('🔔 New Rule Activity:');
      console.log('━'.repeat(25));
      
      newActivity.forEach(activity => {
        const time = new Date(activity.timestamp).toLocaleTimeString();
        console.log(`[${time}] ${activity.message}`);
      });
      
      console.log('');
      this.lastActivity = Date.now();
    }
  }

  getNewActivity() {
    if (!fs.existsSync(this.activityFile)) {
      return [];
    }

    try {
      const content = fs.readFileSync(this.activityFile, 'utf8');
      const lines = content.trim().split('\n').filter(line => line.length > 0);
      
      return lines
        .map(line => {
          const match = line.match(/^\\[(.*?)\\] (.*)$/);
          if (match) {
            return {
              timestamp: new Date(match[1]).getTime(),
              message: match[2]
            };
          }
          return null;
        })
        .filter(activity => activity && activity.timestamp > this.lastActivity)
        .sort((a, b) => a.timestamp - b.timestamp);
        
    } catch (e) {
      return [];
    }
  }

  static logActivity(message) {
    const activityFile = path.join(PORT42_HOME, 'memory', 'rule-activity.log');
    const timestamp = new Date().toISOString();
    const logLine = `[${timestamp}] ${message}\n`;
    
    try {
      fs.appendFileSync(activityFile, logLine);
    } catch (e) {
      // Silent fail - don't break rule execution
    }
  }
}

const watcher = new UnifiedRuleWatcher();
watcher.start();
EOF

# Make everything executable
chmod +x ~/.port42-premise/port42-premise
chmod +x ~/.port42-premise/lib/possess-claude.js
chmod +x ~/.port42-premise/lib/data-rules.js
chmod +x ~/.port42-premise/lib/rule-watcher.js

# Add to PATH
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

if ! grep -q "port42-premise" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# Port 42 Premise v0.4 (Three Models)" >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/.port42-premise/bin:\$PATH\"" >> "$SHELL_RC"
    echo "alias port42-premise=\"\$HOME/.port42-premise/port42-premise\"" >> "$SHELL_RC"
fi

echo "✅ Port 42 Premise v0.4 installed with Four Models!"
echo ""
echo "🎯 NEW: Four Models Support"
echo "  🔧 TOOLS - Executable commands (existing functionality)"
echo "  📄 DOCUMENTS - Living knowledge that evolves through conversation" 
echo "  🎨 ARTIFACTS - Any digital creation (apps, designs, presentations)"
echo "  💾 DATA - Structured data systems with CRUD operations"
echo ""
echo "🔮 NEW: /crystallize Commands"
echo "  /crystallize           - AI decides which model to use"
echo "  /crystallize tool      - Create executable command"
echo "  /crystallize document  - Create/update knowledge document"
echo "  /crystallize artifact  - Create digital artifact"
echo "  /crystallize data      - Create structured data system"
echo ""
echo "🚀 Quick start:"
echo "   1. source $SHELL_RC"  
echo "   2. export ANTHROPIC_API_KEY='your-key'"
echo "   3. port42-premise init"
echo "   4. port42-premise possess claude"
echo ""
echo "🐬 The dolphins are ready for three-dimensional creation..."
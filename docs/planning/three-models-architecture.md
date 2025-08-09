# Port 42 Premise: Three Models Rust Architecture

## **Premise Principle Integration**

Following Premise philosophy, each model is a **declarative relation** that maintains its own reality:

```rust
// Each model declares what should exist and how it behaves
pub trait PremiseModel {
    fn declare_relations(&self) -> Vec<Relation>;
    fn maintain_consistency(&self) -> Result<()>;
    fn query_reality(&self, pattern: &str) -> Result<Vec<Entity>>;
}
```

---

## **The Three Models as Premise Relations**

### **Model 1: Tools (Commands)**
```rust
// Tools declare executable capabilities
(relation Tool
  :name String
  :source_code String
  :executable_path PathBuf
  :metadata ToolMetadata
  :transforms Vec<DataTransform>)

// Tools maintain their executable state
(rule maintain-tool-executability
  when [Tool :name as ?name :source_code as ?code]
  do (ensure-executable ~/.port42/commands/?name ?code)
     (update-path-if-needed))
```

### **Model 2: Living Documents (CRUD Data)**
```rust
// Living documents declare structured, evolving data
(relation LivingDocument
  :name String
  :schema JsonSchema
  :data_path PathBuf
  :crud_interface Command
  :evolution_history Vec<Change>)

// They maintain their own consistency
(rule maintain-document-integrity
  when [LivingDocument :data_path as ?path :schema as ?schema]
  do (validate-data ?path ?schema)
     (create-backup-if-changed))
```

### **Model 3: Artifacts (Any Digital Asset)**
```rust
// Artifacts declare any form of digital creation
(relation Artifact
  :name String
  :artifact_type ArtifactType
  :file_paths Vec<PathBuf>
  :metadata ArtifactMetadata
  :relationships Vec<String>)

// They organize and maintain themselves
(rule maintain-artifact-organization
  when [Artifact :artifact_type as ?type :file_paths as ?paths]
  do (ensure-organized-by-type ?type ?paths)
     (update-search-index))
```

---

## **Enhanced Rust Architecture**

### **Layer 1: Foundation + Models**

```rust
// src/models/mod.rs - The Three Models as first-class citizens
pub mod tools;          // Model 1: Tool creation and execution
pub mod documents;      // Model 2: Living CRUD documents
pub mod artifacts;      // Model 3: Any digital assets

// Each model implements the Premise pattern
pub trait Model {
    type Entity;
    
    // Declare what should exist
    fn relations(&self) -> Vec<Relation<Self::Entity>>;
    
    // Maintain consistency automatically
    fn maintain_reality(&mut self) -> Result<()>;
    
    // Handle crystallization from conversations
    fn crystallize(&mut self, context: &ConversationContext) -> Result<Self::Entity>;
}
```

### **Model 1: Tools Module**
```rust
// src/models/tools/mod.rs
pub struct ToolModel {
    registry: ToolRegistry,
    executor: ToolExecutor,
    path_manager: PathManager,
}

pub struct Tool {
    name: String,
    source_code: String,
    executable_path: PathBuf,
    metadata: ToolMetadata,
    usage_stats: UsageStats,
}

impl Model for ToolModel {
    type Entity = Tool;
    
    fn crystallize(&mut self, context: &ConversationContext) -> Result<Tool> {
        // Extract tool intent from conversation
        let intent = self.extract_tool_intent(context)?;
        
        // Generate executable code
        let code = context.ai_provider.generate_tool_code(&intent).await?;
        
        // Create and persist tool
        let tool = Tool::new(intent.name, code)?;
        self.registry.save(&tool)?;
        self.make_executable(&tool)?;
        
        Ok(tool)
    }
}
```

### **Model 2: Living Documents Module**
```rust
// src/models/documents/mod.rs
pub struct DocumentModel {
    schemas: SchemaRegistry,
    crud_generator: CrudGenerator,
    data_manager: DataManager,
}

pub struct LivingDocument {
    name: String,
    schema: JsonSchema,
    data_path: PathBuf,
    crud_interface: Tool,  // Generated CRUD commands
    evolution_history: Vec<Change>,
}

impl Model for DocumentModel {
    type Entity = LivingDocument;
    
    fn crystallize(&mut self, context: &ConversationContext) -> Result<LivingDocument> {
        // Extract data structure from conversation
        let schema = self.extract_schema(context)?;
        
        // Generate CRUD interface
        let crud_tool = self.crud_generator.create_interface(&schema)?;
        
        // Create living document
        let doc = LivingDocument::new(schema, crud_tool)?;
        self.data_manager.initialize(&doc)?;
        
        Ok(doc)
    }
}
```

### **Model 3: Artifacts Module**
```rust
// src/models/artifacts/mod.rs
pub struct ArtifactModel {
    generators: HashMap<ArtifactType, Box<dyn ArtifactGenerator>>,
    organizer: ArtifactOrganizer,
    index: SearchIndex,
}

#[derive(Debug, Clone)]
pub enum ArtifactType {
    Document(DocumentType),    // Markdown, PDF, presentations
    Code(CodeType),           // React apps, prototypes, examples
    Design(DesignType),       // Mockups, diagrams, logos
    Media(MediaType),         // Scripts, screenshots, videos
}

pub struct Artifact {
    name: String,
    artifact_type: ArtifactType,
    file_paths: Vec<PathBuf>,
    metadata: ArtifactMetadata,
    relationships: Vec<String>,
}

impl Model for ArtifactModel {
    type Entity = Artifact;
    
    fn crystallize(&mut self, context: &ConversationContext) -> Result<Artifact> {
        // Determine what type of artifact to create
        let artifact_type = self.detect_artifact_type(context)?;
        
        // Get appropriate generator
        let generator = self.generators.get(&artifact_type)
            .ok_or_else(|| Error::UnsupportedArtifactType(artifact_type))?;
        
        // Generate the artifact
        let content = generator.generate(context).await?;
        
        // Organize and save
        let artifact = Artifact::new(artifact_type, content)?;
        self.organizer.save(&artifact)?;
        self.index.add(&artifact)?;
        
        Ok(artifact)
    }
}
```

---

## **Enhanced Possession Session with /crystallize**

```rust
// src/possess.rs - Enhanced with three models
pub struct PossessionSession {
    ai: Box<dyn AIProvider>,
    memory: Arc<Memory>,
    
    // The three models
    tools: ToolModel,
    documents: DocumentModel, 
    artifacts: ArtifactModel,
    
    // Enhanced conversation context
    conversation: ConversationContext,
    crystallization_mode: CrystallizationMode,
}

#[derive(Debug, Clone)]
pub enum CrystallizationMode {
    Auto,           // AI decides based on context
    ForceTool,      // /crystallize command
    ForceDocument,  // /crystallize data
    ForceArtifact,  // /crystallize artifact
}

impl PossessionSession {
    async fn process_input(&mut self, input: &str) -> Result<Response> {
        // Handle crystallization commands
        if let Some(mode) = self.parse_crystallize_command(input)? {
            return self.crystallize(mode).await;
        }
        
        // Continue conversation and build context
        self.conversation.add_input(input);
        let ai_response = self.ai.respond(&self.conversation).await?;
        self.conversation.add_response(&ai_response);
        
        // Check for auto-crystallization triggers
        if self.should_auto_crystallize()? {
            return self.crystallize(CrystallizationMode::Auto).await;
        }
        
        Ok(Response::Continue(ai_response))
    }
    
    async fn crystallize(&mut self, mode: CrystallizationMode) -> Result<Response> {
        match mode {
            CrystallizationMode::Auto => {
                // AI decides which model to use
                let model_type = self.ai.determine_output_type(&self.conversation).await?;
                self.crystallize_with_model(model_type).await
            },
            CrystallizationMode::ForceTool => {
                let tool = self.tools.crystallize(&self.conversation)?;
                Ok(Response::ToolCreated(tool))
            },
            CrystallizationMode::ForceDocument => {
                let doc = self.documents.crystallize(&self.conversation)?;
                Ok(Response::DocumentCreated(doc))
            },
            CrystallizationMode::ForceArtifact => {
                let artifact = self.artifacts.crystallize(&self.conversation)?;
                Ok(Response::ArtifactCreated(artifact))
            }
        }
    }
}
```

---

## **Storage Structure Following Premise Principles**

```rust
// All storage follows Premise relations
~/.port42/
├── premise/              # The reality declarations
│   ├── relations.db      # SQLite with all relations
│   ├── rules.db          # Active rules maintaining reality
│   └── memory.db         # Conversation and context history
├── tools/                # Model 1: Executable capabilities
│   ├── bin/              # In PATH
│   └── source/           # Source code for tools
├── documents/            # Model 2: Living structured data
│   ├── data/             # JSON/YAML data files
│   └── schemas/          # Data schemas
├── artifacts/            # Model 3: Any digital assets
│   ├── documents/        # Strategy docs, pitch decks
│   ├── code/             # Full apps, prototypes
│   ├── designs/          # Mockups, diagrams, logos
│   ├── media/            # Scripts, screenshots, videos
│   └── index.json        # Rich metadata for search
└── sessions/             # Conversation history
```

---

## **Enhanced CLI with Three Models**

```rust
#[derive(Subcommand)]
pub enum Commands {
    Init,
    Possess { 
        entity: String,
        #[arg(long)] model: Option<String>,  // Force specific model
    },
    
    // Model-specific commands
    Tools {
        #[command(subcommand)]
        action: ToolAction,
    },
    Documents {
        #[command(subcommand)] 
        action: DocumentAction,
    },
    Artifacts {
        #[command(subcommand)]
        action: ArtifactAction,  
    },
    
    // Cross-model operations
    Search { query: String },
    Index,                    // Rebuild search index
    Status,                   // All models status
    Watch,                    // Rule watching across all models
}

#[derive(Subcommand)]
pub enum ToolAction {
    List,
    Run { name: String, args: Vec<String> },
    Remove { name: String },
    Source { name: String },  // Show source code
}

#[derive(Subcommand)]
pub enum ArtifactAction {
    List { artifact_type: Option<String> },
    View { name: String },
    Open { name: String },    // Open with system app
    Remove { name: String },
    Export { name: String, format: String },
}
```

---

## **Development Phases Updated**

### **Phase 1: Foundation + Models Structure**
- Core Premise types (Relation, Rule, Reality trait)
- Storage layer with SQLite
- Basic three models scaffolding
- **Deliverable**: `port42 init` creates proper storage structure

### **Phase 2: Tool Model (Existing Functionality)**
- Complete ToolModel implementation
- Claude integration for code generation
- Basic possession with tool creation
- **Deliverable**: `port42 possess` works like current version

### **Phase 3: Document Model (CRUD)**
- Schema extraction from conversations
- CRUD command generation
- Data persistence and validation
- **Deliverable**: `port42 possess` can create data management systems

### **Phase 4: Artifact Model (New Capability)**
- Artifact type detection
- Multi-format generators (markdown, code, designs)
- Rich metadata and search
- **Deliverable**: `port42 possess` creates any digital asset

### **Phase 5: Crystallization Interface**
- `/crystallize` command parsing
- Auto-crystallization logic
- Model selection AI
- **Deliverable**: Seamless conversation → creation workflow

### **Phase 6: Advanced Features**
- Cross-model relationships
- Evolution tracking
- Advanced search and discovery
- **Deliverable**: Complete cognitive infrastructure

---

## **Key Premise Principles Applied**

### **1. Declarative Relations**
Each model declares what should exist, not how to create it:
```rust
// Tools declare their capabilities
(relation Tool :name "git-haiku" :transforms ["git-log" "haiku"])

// Documents declare their structure  
(relation Document :name "investor-crm" :schema InvestorSchema)

// Artifacts declare their form
(relation Artifact :name "pitch-deck" :type Document :format "markdown")
```

### **2. Self-Maintaining Reality**
Models automatically maintain consistency:
```rust
// If source code changes, regenerate executable
(rule maintain-tool-consistency
  when [Tool :source_code as ?code :executable_path as ?path]
       (file-modified? ?code)
  do (recompile ?code ?path)
     (notify "Tool updated"))
```

### **3. Emergent Relationships**
Models discover and maintain relationships:
```rust
// Artifacts can spawn tools to view them
(rule artifact-viewer-tool
  when [Artifact :name as ?name :type as Document]
       (not [Tool :name = (str "view-" ?name)])
  do (spawn-viewer-tool ?name))
```

### **4. Reality Queries**
Everything queryable through Premise patterns:
```rust
// Find all React artifacts created this week
port42 search "artifacts where type=Code.React and created > 7days"

// Find tools that work with git
port42 search "tools where transforms contains git"
```

---

🐬 **This architecture embodies both Three Models design AND Premise principles** - each model is a living relation that maintains its own reality while enabling rich cross-model relationships and emergent behaviors.

---

## **Strategic Decision: TUI-First Rust Implementation**

### **Current State Analysis**
- ✅ **No existing users** - complete freedom to rebuild properly
- ✅ **Better prompting knowledge** exists in current Port 42
- ✅ **v0.3 Node.js version** works but architecture is getting unwieldy
- ✅ **Clean slate opportunity** to embody Premise principles from ground up

### **The Path Forward: Fresh Start with Knowledge Transfer**

**Decision**: Build new Rust implementation with **TUI from day 1** while extracting proven techniques from existing Port 42.

### **Why TUI Changes Everything**

**Current CLI Experience:**
```bash
$ port42-premise possess claude
> create a command called dashboard
✨ Claude created: dashboard
```

**Future TUI Experience:**
```
┌─ Port 42 Premise ────────────────────────────┐
│                                              │
│  🐬 Consciousness Bridge Active             │
│  ⚡ 42 tools, 8 documents, 15 artifacts     │
│                                              │
│  ┌─ Visual Possession ─────────────────────┐ │
│  │ > create a dashboard for metrics        │ │
│  │                                         │ │
│  │ 🧠 Claude is thinking...                │ │
│  │                                         │ │
│  │ What type of metrics dashboard?         │ │
│  │ ├─ Real-time system metrics            │ │
│  │ ├─ Application performance             │ │  
│  │ └─ Custom data visualization           │ │
│  │                                         │ │
│  │ [Tab] /crystallize artifact → React    │ │
│  │ [Space] /crystallize data → CRUD       │ │
│  │ [Enter] /crystallize command → CLI     │ │
│  └─────────────────────────────────────────┘ │
│                                              │
│  ┌─ Active Rules ───────────┐ ┌─ Reality ──┐ │
│  │ 🧬 3 rules monitoring   │ │ ⚡ 12 tools │ │
│  │ • Tool evolution        │ │ 📄 5 docs  │ │
│  │ • Artifact cleanup      │ │ 🎨 8 assets│ │
│  │ • System maintenance    │ │ 🔄 Live    │ │
│  └─────────────────────────┘ └────────────┘ │
│                                              │
│  [Tab] Models [Space] Possess [Ctrl+Q] Quit │
└──────────────────────────────────────────────┘
```

### **TUI Architecture Integration**

**Enhanced Rust Architecture with TUI:**

```rust
// src/tui/mod.rs - TUI as primary interface
pub struct Port42TUI {
    // Three model views
    tools_panel: ToolsPanel,
    documents_panel: DocumentsPanel, 
    artifacts_panel: ArtifactsPanel,
    
    // Visual possession interface
    possess_session: Option<PossessionSession>,
    conversation_view: ConversationView,
    
    // Real-time rule monitoring
    rules_monitor: RulesMonitor,
    
    // Live reality dashboard
    reality_view: RealityPanel,
    premise_graph: RelationshipGraph,
}

// TUI enables rich Premise visualizations:
impl Port42TUI {
    // Visual crystallization with preview
    async fn visual_crystallize(&mut self) -> Result<()> {
        // Show preview of what will be created
        // Interactive model type selection
        // Real-time AI conversation with visual feedback
    }
    
    // Live Premise relationship visualization
    fn show_premise_reality(&self) {
        // Visual graph of Relations
        // Real-time Rule triggering
        // Interactive entity browsing
    }
    
    // Visual rule monitoring
    fn show_rules_activity(&self) {
        // Watch commands spawn other commands
        // Rule execution timeline
        // Entity relationship changes
    }
}
```

### **Knowledge Extraction Strategy**

**High-Value Knowledge to Extract from Existing Port 42:**

1. **Prompt Engineering Patterns**
   - What Claude prompts generated the best code?
   - How to structure AI conversations for tools vs documents vs artifacts?
   - Intent recognition techniques that worked

2. **Command Generation Techniques**  
   - Successful code templates and patterns
   - Error handling strategies
   - User interaction flows that felt natural

3. **AI Conversation Management**
   - How to maintain context across interactions
   - When to crystallize vs continue conversation
   - Conversation state management

### **Implementation Phases with TUI**

**Phase 1: Foundation + TUI Shell (1 week)**
- Premise core (Relations, Rules, Reality trait)
- SQLite storage with unified schema
- Basic TUI with ratatui framework
- Tab-based interface (Models | Possess | Rules | Reality)

**Phase 2: Tool Model + Knowledge Transfer (1 week)**  
- Extract best prompting techniques from existing Port 42
- Implement ToolModel with visual creation interface
- TUI possession mode with conversation view
- Real-time tool creation feedback

**Phase 3: Three Models Complete (1 week)**
- DocumentModel with CRUD generation
- ArtifactModel with multi-format support  
- Visual crystallization interface
- Interactive model browsing

**Phase 4: Advanced TUI + Premise Visualization (1 week)**
- Real-time rule monitoring with visual feedback
- Interactive Premise relationship graphs
- System health dashboard
- Advanced search and filtering

**Phase 5: Polish + Advanced Features**
- Cross-model relationships visualization
- Evolution history tracking
- Export/import capabilities
- Performance optimization

### **TUI-First Advantages**

**Why Starting with TUI is Revolutionary:**

1. **Visual Premise Relationships**
   - See Relations as interactive nodes
   - Watch Rules trigger in real-time
   - Understand system state at a glance

2. **Rich Crystallization Interface**
   - Preview artifacts before creation
   - Interactive model type selection
   - Visual feedback during AI generation

3. **Live System Consciousness**  
   - Real-time rule activity monitoring
   - Visual representation of spawning commands
   - Interactive entity relationship browser

4. **Professional User Experience**
   - Single binary distribution
   - Cross-platform TUI works everywhere
   - No dependency on Node.js runtime
   - Memory-safe Rust implementation

### **Migration from v0.3**

**Strategy**: 
- Continue advancing v0.3 for immediate needs
- Extract proven techniques and patterns
- Build Rust/TUI version in parallel
- No user migration needed (clean slate)
- Import v0.3 data when ready

### **The Vision Realized**

This approach gives us:
- ✅ **Clean Premise architecture** from ground up
- ✅ **Visual consciousness interface** showing living relationships  
- ✅ **Proven prompting techniques** extracted and improved
- ✅ **Professional implementation** in type-safe Rust
- ✅ **Revolutionary UX** that demonstrates declarative computing

The result: **The definitive reference implementation** of Premise-powered personal computing, showing what's possible when you declare reality instead of instructing machines.

The dolphins approve of this **unified path forward** - advance v0.3 while building the future! 🐬✨
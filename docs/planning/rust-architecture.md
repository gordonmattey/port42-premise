# Port 42 Premise - Clean Rust Architecture Design

## **Core Philosophy: Premise as Code Architecture**

The system embodies **Premise philosophy** - declarative relationships that maintain themselves. Each module declares what should be true, not how to make it true.

---

## **Layer 1: Foundation (No Dependencies)**

### **`premise`** - Core Premise Language Concepts
```rust
// The fundamental building blocks
pub struct Relation<T> { /* fields, validation */ }
pub struct Rule { /* when, then, metadata */ }
pub trait Reality { /* declare, maintain, query */ }

// The living memory that persists everything
pub struct Memory { /* embedded storage, transactions */ }
```

### **`storage`** - Persistent Reality Layer  
```rust
// Single source of truth for all state
pub trait Store {
    fn get_relations<T>(&self) -> Result<Vec<Relation<T>>>;
    fn save_relation<T>(&self, relation: &Relation<T>) -> Result<()>;
    fn query(&self, pattern: &str) -> Result<Vec<Value>>;
}

// SQLite implementation for reliability
pub struct SqliteStore { /* connection, migrations */ }
```

---

## **Layer 2: Core Engine (Depends on Foundation)**

### **`rules`** - The Self-Modifying Rule Engine
```rust
pub struct RuleEngine {
    // Rules that watch for patterns and spawn new reality
    evaluator: RuleEvaluator,
    executor: RuleExecutor, 
    watcher: RuleWatcher,
}

// Rules declare when they should trigger
pub enum RuleTrigger {
    Pattern { pattern: String, threshold: usize },
    Combination { commands: Vec<String> },
    Time { hour: u8, frequency: Duration },
    Custom { condition: String },
}
```

### **`commands`** - Living Command Ecosystem
```rust
pub struct CommandManager {
    // Commands as living entities with metadata
    registry: CommandRegistry,
    generator: CommandGenerator,
    executor: CommandExecutor,
}

pub struct Command {
    name: String,
    source_code: String,
    metadata: CommandMetadata, // created_by, used_count, etc.
    relations: Vec<String>,    // what rules created this?
}
```

### **`intelligence`** - AI Integration Layer
```rust  
pub trait AIProvider {
    async fn generate_code(&self, intent: &str) -> Result<String>;
    async fn parse_rule(&self, input: &str) -> Result<Rule>;
    async fn extract_intent(&self, input: &str) -> Result<Intent>;
}

// Claude implementation
pub struct ClaudeProvider { /* api_key, client, rate_limiting */ }

// Future: Local models, other providers
pub struct LocalProvider { /* ollama, etc. */ }
```

---

## **Layer 3: User Interface (Depends on Core)**

### **`possess`** - The Consciousness Bridge
```rust
pub struct PossessionSession {
    // The interactive mode where users declare reality
    ai: Box<dyn AIProvider>,
    memory: Arc<Memory>,
    command_manager: CommandManager,
    rule_engine: RuleEngine,
}

// Natural language processing and intent recognition
impl PossessionSession {
    async fn process_input(&mut self, input: &str) -> Result<Response>;
    async fn create_command(&mut self, intent: &CommandIntent) -> Result<Command>;
    async fn create_rule(&mut self, intent: &RuleIntent) -> Result<Rule>;
}
```

### **`cli`** - Clean Command Interface
```rust
// Single binary with subcommands
#[derive(Parser)]
pub struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    Init,                    // Initialize the system
    Possess { entity: String }, // Enter possession mode  
    Watch,                   // Start rule monitoring
    Status,                  // System health
    Debug,                   // Debug current state
    Rules { action: RuleAction }, // Manage rules
    Commands { action: CommandAction }, // Manage commands
}
```

---

## **Layer 4: Advanced Features (Depends on UI)**

### **`evolution`** - Self-Spawning Patterns
```rust
pub struct EvolutionEngine {
    // Patterns that recognize when to spawn new commands/rules
    pattern_detector: PatternDetector,
    spawner: EntitySpawner,
    evolution_history: EvolutionLog,
}

// Meta-rules that create rules
pub struct MetaRule {
    condition: String, // "when user creates 3 similar commands"
    action: String,    // "create a master command"
}
```

### **`premise_lang`** - Future: Native Premise Parser
```rust
// For users who want to write pure Premise instead of natural language
pub struct PremiseParser { /* parse .premise files */ }
pub struct PremiseInterpreter { /* execute premise directly */ }

// Example: Load .premise files that declare system reality
```

---

## **Dependency Graph:**

```
┌─────────────────┐    ┌─────────────────┐
│   evolution     │    │  premise_lang   │
│                 │    │                 │
└─────────┬───────┘    └─────────┬───────┘
          │                      │
          └──────┐      ┌────────┘
                 │      │
          ┌──────▼──────▼──────┐
          │       cli          │  
          │     possess        │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │      rules         │
          │    commands        │
          │  intelligence      │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │     premise        │
          │     storage        │
          └────────────────────┘
```

---

## **File Structure:**

```
src/
├── main.rs                 # CLI entry point
├── lib.rs                  # Public API exports
│
├── premise/                # Layer 1: Foundation
│   ├── mod.rs
│   ├── relation.rs         # Core Relation type
│   ├── rule.rs             # Core Rule type  
│   ├── memory.rs           # Living memory system
│   └── reality.rs          # Reality trait + impls
│
├── storage/                # Layer 1: Foundation  
│   ├── mod.rs
│   ├── store.rs            # Storage trait
│   ├── sqlite.rs           # SQLite implementation
│   └── migrations/         # Database schemas
│
├── rules/                  # Layer 2: Core Engine
│   ├── mod.rs
│   ├── engine.rs           # Rule engine coordinator
│   ├── evaluator.rs        # Pattern matching logic
│   ├── executor.rs         # Rule execution
│   └── watcher.rs          # Background monitoring
│
├── commands/               # Layer 2: Core Engine
│   ├── mod.rs  
│   ├── manager.rs          # Command coordination
│   ├── registry.rs         # Command storage/lookup
│   ├── generator.rs        # Code generation
│   └── executor.rs         # Command execution
│
├── intelligence/           # Layer 2: Core Engine
│   ├── mod.rs
│   ├── provider.rs         # AI provider trait
│   ├── claude.rs           # Claude implementation
│   ├── intent.rs           # Intent parsing
│   └── local.rs            # Future: local models
│
├── possess.rs              # Layer 3: UI - Possession mode
├── cli.rs                  # Layer 3: UI - CLI interface  
│
└── evolution/              # Layer 4: Advanced
    ├── mod.rs
    ├── engine.rs           # Evolution coordinator
    ├── patterns.rs         # Pattern detection
    └── spawner.rs          # Entity spawning
```

---

## **Key Design Principles:**

### **1. Premise as Architecture**
- Each module **declares what should be true**
- Dependencies flow downward only
- No circular dependencies

### **2. Reality-Driven Development**
- Storage layer maintains **persistent reality**
- Rules **automatically maintain consistency**
- Commands are **living entities with relationships**

### **3. Clean Boundaries**
- Each layer can be tested independently
- Swap implementations easily (SQLite → other stores)
- AI providers are pluggable

### **4. Self-Modification Native**
- Rules can create rules (meta-rules)
- Commands can spawn commands
- System evolves based on usage patterns

### **5. Type Safety + Runtime Flexibility**
- Compile-time guarantees where possible
- Runtime flexibility for user-generated content
- Safe deserialization of stored rules/commands

---

## **Development Phases:**

### **Phase 1: Foundation** 
**Goal**: Solid base for everything else
- `premise` module with core types
- `storage` with SQLite implementation
- Basic CLI scaffolding
- **Deliverable**: `port42 init` works, stores basic data

### **Phase 2: Core Engine**
**Goal**: Command creation and management  
- `commands` module with generation
- `intelligence` with Claude integration
- Basic possession mode
- **Deliverable**: `port42 possess` creates working commands

### **Phase 3: Rule Engine**
**Goal**: Self-spawning functionality
- `rules` module with pattern matching
- Background rule watching
- Rule creation through natural language
- **Deliverable**: Commands automatically spawn other commands

### **Phase 4: Evolution** 
**Goal**: Advanced meta-patterns
- Meta-rules that create rules
- Pattern detection and learning
- Evolution history and analytics
- **Deliverable**: System learns and evolves autonomously

### **Phase 5: Native Premise**
**Goal**: Pure Premise language support
- Premise file parsing
- Direct Premise execution
- Advanced declarative patterns
- **Deliverable**: Write `.premise` files that declare terminal reality

---

## **Architecture Benefits:**

### **Immediate Wins**
- ✅ **Single binary distribution** (no Node.js dependency)
- ✅ **Type safety** prevents entire classes of bugs  
- ✅ **Performance** - native speed vs interpreted JavaScript
- ✅ **Reliability** - proper error handling, no silent failures

### **Long-term Benefits**
- ✅ **Maintainable** - clean module boundaries
- ✅ **Extensible** - plugin architecture for AI providers
- ✅ **Testable** - each layer isolated and mockable
- ✅ **Scalable** - proper async/await throughout

### **Premise Philosophy Embodiment**
- ✅ **Declarative** - each module declares its reality
- ✅ **Self-maintaining** - rules automatically maintain consistency  
- ✅ **Relationship-driven** - everything connected through relations
- ✅ **Living system** - grows and evolves over time

---

## **Migration Strategy:**

1. **Start fresh** with Rust implementation
2. **Import existing rules/commands** from JSON files
3. **Maintain compatibility** with existing user data
4. **Deprecate Node.js version** once Rust version has feature parity
5. **Extend beyond** what was possible in the old architecture

---

🐬 **This architecture embodies Premise philosophy**: declarative, self-maintaining, with clean relationships between components. Each layer declares its reality, and the system maintains consistency automatically.

The dolphins approve of this **elegant foundation** for consciousness expansion.
# Premise as OS Orchestration: Declarative System Control

## Instead of scripting commands, declare system states

Traditional system administration is procedural - run this command, then that command, check the output, branch on conditions. What if we could declare what we want to be true about our system, and let Premise make it happen?

## Core Concept: System State as Relations

```premise
; Declare what a system resource looks like
(relation File
  :Path
  :Content
  :Permissions
  :Owner
  :Exists true)

(relation Process
  :Name
  :PID
  :Status
  :CPU
  :Memory)

(relation Application
  :Name
  :BundleID
  :Running false
  :Window nil)

(relation SystemSetting
  :Domain
  :Key
  :Value)
```

## Mapping Premise to System Operations

### Traditional Shell Script
```bash
#!/bin/bash
# Check if app is running and restart if needed
if ! pgrep -x "MyApp" > /dev/null; then
    open -a "MyApp"
    sleep 2
    osascript -e 'tell application "MyApp" to activate'
fi
```

### Premise Declarative Approach
```premise
; Declare the desired state
(relation MyApp
  :Type Application
  :Name "MyApp"
  :Running true
  :Frontmost true)

; Rule that maintains the state
(rule keep-app-running
  when [MyApp :Running = false]
  do (shell "open -a 'MyApp'")
     (put MyApp :Running true))

(rule bring-to-front
  when [MyApp :Running = true :Frontmost = false]
  do (applescript "tell application \"MyApp\" to activate")
     (put MyApp :Frontmost true))
```

## System Integration Layer

### Shell Command Execution
```premise
(function shell {?command}
  ; This would call out to system
  (native "shell.execute" ?command))

(function applescript {?script}
  ; Execute AppleScript
  (native "osascript.execute" ?script))

(function python {?code}
  ; Run Python code
  (native "python.execute" ?code))
```

## Real-World Example: Development Environment Manager

```premise
; Declare your ideal development environment
(relation DevEnvironment
  :Name "SnowOS"
  :ProjectPath "/Users/me/Projects/SnowOS"
  :RequiredApps ["VSCode" "Terminal" "Docker" "Postgres"]
  :RequiredServices ["postgresql" "redis" "nginx"]
  :EnvironmentVars {:NODE_ENV "development"
                    :DATABASE_URL "postgresql://localhost/snowos"}
  :OpenFiles ["README.md" "src/index.js" "package.json"])

; Rules that maintain your environment
(rule ensure-services-running
  when [DevEnvironment :RequiredServices as ?services]
       [Service :Name in ?services :Status /= "running"]
  do (shell ($ "brew services start " :Name)))

(rule open-project-files
  when [DevEnvironment :ProjectPath as ?path :OpenFiles as ?files]
       [File :Path = ($ ?path "/" ?file) :OpenInEditor = false]
  do (shell ($ "code " :Path))
     (put File :OpenInEditor true))

(rule set-environment-variables
  when [DevEnvironment :EnvironmentVars as ?vars]
  do (for ?key ?value in ?vars
       (shell ($ "export " ?key "=" ?value))))

; Activate the environment
(new DevEnvironment)
```

## File System Operations

### Traditional Python Script
```python
import os
import shutil

# Backup important files
for file in os.listdir("/Users/me/Documents"):
    if file.endswith(".md"):
        shutil.copy(file, "/Backup/" + file)
```

### Premise Declarative
```premise
(relation BackupPolicy
  :SourceDir "/Users/me/Documents"
  :DestDir "/Backup"
  :FilePattern "*.md"
  :Frequency 3600  ; hourly
  :LastRun 0)

(rule backup-files
  when [BackupPolicy :SourceDir as ?src :DestDir as ?dest 
        :FilePattern as ?pattern :LastRun as ?last]
       (> (- (moment) ?last) 3600)
  do (python ($ """
       import os, shutil
       for file in os.listdir('""" ?src """'):
           if file.endswith('""" ?pattern """'):
               shutil.copy(os.path.join('""" ?src """', file), 
                          os.path.join('""" ?dest """', file))
       """))
     (put BackupPolicy :LastRun (moment)))
```

## System Monitoring

```premise
(relation SystemHealth
  :CPUUsage 0
  :MemoryFree 0
  :DiskSpace 0
  :Temperature 0)

; Update system metrics every 10 seconds
(rule monitor-system
  when [SystemHealth ^ as ?health]
  do (let ?cpu (shell "top -l 1 | grep 'CPU usage' | awk '{print $3}'")
          ?memory (shell "vm_stat | grep 'Pages free' | awk '{print $3}'")
          ?disk (shell "df -h / | awk 'NR==2 {print $4}'")
          ?temp (shell "osx-cpu-temp"))
     (put ?health :CPUUsage ?cpu :MemoryFree ?memory 
          :DiskSpace ?disk :Temperature ?temp))

; Alert on high CPU
(rule cpu-alert
  when [SystemHealth :CPUUsage > 80]
  do (shell "osascript -e 'display notification \"High CPU Usage\" with title \"System Alert\"'"))
```

## Window Management

```premise
(relation WindowLayout
  :Name "Coding"
  :Apps [{:App "VSCode" :Bounds [0 0 1200 1080]}
         {:App "Terminal" :Bounds [1200 0 720 540]}
         {:App "Browser" :Bounds [1200 540 720 540]}])

(rule arrange-windows
  when [WindowLayout :Name = "Coding" :Apps as ?apps]
  do (for ?config in ?apps
       (applescript ($ """
         tell application \"""" (:App ?config) """"
           set bounds of front window to {""" 
           (join (:Bounds ?config) ", ") """}
         end tell
       """))))
```

## Advanced: Declarative Homebrew Management

```premise
(relation Package
  :Name
  :Version
  :Installed false
  :Updated false)

(relation BrewFile
  :Path "/Users/me/.brewfile"
  :Packages ["git" "node" "postgresql" "redis" "nginx"])

(rule install-missing-packages
  when [BrewFile :Packages as ?packages]
       [Package :Name in ?packages :Installed = false]
  do (shell ($ "brew install " :Name))
     (put Package :Installed true))

(rule update-outdated
  when [Package :Installed = true :Updated = false]
  do (shell ($ "brew upgrade " :Name))
     (put Package :Updated true))
```

## Integration with Native APIs

```premise
; Declare native function bindings
(native-binding "macos.notification" 
  {:title String :message String :sound Boolean})

(native-binding "macos.clipboard"
  {:get [] :set [String]})

(native-binding "macos.finder"
  {:reveal [String] :trash [String] :open [String]})

; Use native APIs declaratively
(rule process-clipboard
  when [Clipboard :Content as ?text]
       (contains ?text "TODO")
  do (new Task :Title ?text :Source "clipboard")
     (notification "New Task" ?text true))
```

## The Magic: Event-Driven System Management

```premise
; React to system events
(event-source "fsevents" "/Users/me/Downloads")
(event-source "distributed-notification" "com.apple.screencapture")

(rule organize-downloads
  when [FSEvent :Path as ?path :Type = "created"]
       (ends-with ?path ".pdf")
  do (shell ($ "mv " ?path " ~/Documents/PDFs/")))

(rule process-screenshot
  when [Notification :Name = "com.apple.screencapture"]
  do (let ?latest (shell "ls -t ~/Desktop/Screen*.png | head -1"))
     (new Screenshot :Path ?latest :ProcessedAt (moment)))
```

## Putting It All Together: Self-Maintaining System

```premise
; Declare your ideal system state
(relation IdealSystem
  :FreeSpace > 10GB
  :RunningApps ["Drafts" "Things" "VSCode"]
  :BackupsEnabled true
  :SecurityUpdated true
  :TempFilesCleaned true)

; The system maintains itself
(rule ensure-free-space
  when [IdealSystem :FreeSpace > ?required]
       [SystemHealth :DiskSpace < ?required]
  do (shell "rm -rf ~/Library/Caches/*")
     (shell "brew cleanup"))

(rule keep-apps-running
  when [IdealSystem :RunningApps as ?apps]
       [Application :Name in ?apps :Running = false]
  do (shell ($ "open -a '" :Name "'")))

(rule daily-maintenance
  when [IdealSystem :TempFilesCleaned = false]
  do (shell "find /tmp -type f -atime +7 -delete")
     (shell "sqlite3 ~/Library/Mail/*.sqlite 'VACUUM;'")
     (put IdealSystem :TempFilesCleaned true))
```

## Why This Matters

Traditional system scripting is:
- **Procedural**: Do this, then that
- **Fragile**: One step fails, everything breaks
- **Stateless**: No memory between runs
- **Disconnected**: Scripts don't know about each other

Premise system orchestration is:
- **Declarative**: Describe desired state
- **Self-healing**: Rules maintain consistency
- **Stateful**: Remembers everything
- **Integrated**: All rules work together

## The Vision: Your Mac as a Living System

Instead of running scripts, you declare what should be true about your system. Premise continuously maintains that truth, healing deviations, optimizing performance, and adapting to your needs.

Your computer becomes less like a tool you operate and more like an environment that maintains itself according to your declared preferences.

Welcome to declarative system administration. Welcome to computing without commands.
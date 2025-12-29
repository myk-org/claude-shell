# Claude Shell

AI-powered shell assistant for Zsh using Claude AI.

## Overview

Claude Shell is an Oh My Zsh plugin that provides intelligent shell assistance using Claude AI. It offers four powerful features to enhance your command-line experience: natural language command translation, command explanation, error fixing, and intelligent history search.

## Features

| Keybinding | Feature | Description |
|------------|---------|-------------|
| **Alt+G** | Natural Language to Shell | Convert plain English to executable commands |
| **Alt+E** | Explain Command | Get detailed explanations of complex commands |
| **Alt+X** | Fix Last Error | Analyze and fix the last failed command |
| **Alt+S** | History Search | Search command history using natural language |

### Common Capabilities

- **Interactive Workflow**: Review and edit suggestions before execution
- **Real-time Feedback**: Visual indicator while processing
- **Error Handling**: Gracefully handles failures and restores your input
- **Clean Output**: Returns focused, actionable results

## Requirements

- [Claude CLI](https://github.com/anthropics/claude-cli) installed and available in PATH
- Valid Claude API credentials configured
- Oh My Zsh installed

## Installation

1. Clone this plugin into your Oh My Zsh custom plugins directory:

```bash
git clone <repository-url> $ZSH_CUSTOM/plugins/claude-shell
```

2. Add `claude-shell` to your plugins array in `~/.zshrc`:

```bash
plugins=(
    # ... other plugins
    claude-shell
)
```

3. Reload your shell configuration:

```bash
omz reload
```

## Usage

### 1. Natural Language to Shell Command (Alt+G)

Convert plain English descriptions into executable shell commands.

**How to use:**
1. Type your natural language request
2. Press `Alt+G`
3. Review the generated command
4. Press `Enter` to execute or edit as needed

**Examples:**

| Natural Language Input | Generated Command |
|------------------------|-------------------|
| `list all python files in current directory` | `ls *.py` |
| `find large files bigger than 100MB` | `find . -type f -size +100M` |
| `count lines in all shell scripts` | `find . -name "*.sh" -exec wc -l {} +` |
| `show disk usage sorted by size` | `du -sh * | sort -h` |
| `search for TODO in all python files` | `grep -r "TODO" --include="*.py" .` |
| `show git log with graph for last 10 commits` | `git log --graph --oneline -10` |
| `undo last commit but keep changes` | `git reset --soft HEAD~1` |

---

### 2. Explain Command (Alt+E)

Get clear, detailed explanations of complex shell commands.

**How to use:**
1. Type or paste a command you want to understand
2. Press `Alt+E`
3. Read the explanation printed to your terminal
4. Original command remains in the buffer

**Examples:**

**Input:** `find . -type f -name "*.log" -mtime +30 -delete`

**Explanation:**
```
This command finds and deletes log files older than 30 days:
- find .           : Start searching from current directory
- -type f          : Look for files only (not directories)
- -name "*.log"    : Match files ending in .log
- -mtime +30       : Modified more than 30 days ago
- -delete          : Remove matched files
```

**Input:** `ps aux | grep python | awk '{print $2}' | xargs kill`

**Explanation:**
```
This command kills all Python processes:
- ps aux           : List all running processes
- grep python      : Filter for processes containing "python"
- awk '{print $2}' : Extract the process ID (column 2)
- xargs kill       : Pass each PID to the kill command
```

---

### 3. Fix Last Error (Alt+X)

Automatically analyze and fix the last failed command.

**How to use:**
1. Run a command that fails
2. Press `Alt+X`
3. Review the suggested fix
4. Press `Enter` to execute or edit as needed

**Examples:**

**Scenario:** Permission denied error
```bash
$ cat /var/log/syslog
cat: /var/log/syslog: Permission denied

# Press Alt+X
$ sudo cat /var/log/syslog
```

**Scenario:** Missing file
```bash
$ cd /tmp/nonexistent
cd: no such file or directory: /tmp/nonexistent

# Press Alt+X
$ mkdir -p /tmp/nonexistent && cd /tmp/nonexistent
```

**Scenario:** Syntax error
```bash
$ find . -name *.txt
find: paths must precede expression: notes.txt

# Press Alt+X
$ find . -name "*.txt"
```

---

### 4. History Search (Alt+S)

Search your command history using natural language descriptions.

**How to use:**
1. Type what you're looking for in plain English
2. Press `Alt+S`
3. Review matching commands from your history
4. Copy and use the command you need

**Examples:**

**Input:** `docker commands from last week`

**Output:**
```
Recent docker commands:
1. docker ps -a
2. docker build -t myapp:latest .
3. docker-compose up -d
4. docker logs myapp
```

**Input:** `git operations on main branch`

**Output:**
```
Git commands involving main:
1. git checkout main
2. git merge feature/new-ui
3. git push origin main
4. git log main --oneline -10
```

**Input:** `find commands for searching files`

**Output:**
```
Find commands from history:
1. find . -name "*.py" -type f
2. find /var/log -mtime +7 -delete
3. find . -size +100M
```

## How It Works

Each feature follows a similar workflow:

1. Captures relevant context (buffer content, last command, exit code, or history)
2. Sends context to Claude CLI with a feature-specific prompt
3. Processes the response for clean, actionable output
4. Updates the buffer or displays results appropriately
5. Positions the cursor for easy interaction

## Configuration

The plugin works out of the box with no additional configuration. However, you can customize the Claude CLI behavior through:

- `~/.claude/settings.json` - Global Claude CLI settings
- Environment variables for Claude API credentials

## Troubleshooting

### Translation fails with error message

- Verify Claude CLI is installed: `which claude`
- Check API credentials are configured: `claude --version`
- Ensure you have an active internet connection

### Command returns markdown formatting

The plugin automatically strips markdown formatting, but if you see backticks or code blocks, ensure you're using the latest version of the plugin.

### Keybinding doesn't work

- Verify the plugin is loaded: `echo $plugins | grep claude-shell`
- Check for keybinding conflicts: `bindkey | grep '\^['` (for Alt key bindings)
- Try reloading your shell: `omz reload`

### No output from Explain (Alt+E) or History Search (Alt+S)

These features print output directly to the terminal rather than replacing the buffer. Check:
- Your terminal scrollback if output seems missing
- Claude CLI is working: `claude "test message"`

### Fix Last Error shows "No previous command found"

The Alt+X feature requires:
- A command to have been executed previously in the session
- The `fc` command to access history (available in most Zsh configurations)

## License

This plugin is provided as-is for personal and commercial use.

## Contributing

Contributions are welcome. Please ensure:
- Code follows existing style conventions
- Changes are tested with multiple natural language inputs
- Documentation is updated accordingly

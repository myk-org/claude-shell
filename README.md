# Claude Shell

AI-powered shell assistant for Zsh using Claude AI.

## Overview

Claude Shell is an Oh My Zsh plugin that provides intelligent shell assistance using Claude AI. It offers six powerful features to enhance your command-line experience: natural language command translation, command explanation, error fixing, intelligent history search, and Kitty terminal integration for advanced scrollback analysis.

## Features

| Keybinding | Feature | Description |
|------------|---------|-------------|
| **Alt+G** | Natural Language to Shell | Convert plain English to executable commands |
| **Alt+E** | Explain Command | Get detailed explanations of complex commands |
| **Alt+X** | Fix Last Error | Analyze and fix the last failed command |
| **Alt+S** | History Search | Search command history using natural language |
| **Alt+W** | What Went Wrong? | Analyze scrollback buffer for errors (Kitty only) |
| **Alt+Q** | Quick Summary | Summarize current screen output (Kitty only) |

### Common Capabilities

- **Interactive Workflow**: Review and edit suggestions before execution
- **Real-time Feedback**: Visual indicator while processing
- **Error Handling**: Gracefully handles failures and restores your input
- **Clean Output**: Returns focused, actionable results

## Requirements

- [Claude CLI](https://github.com/anthropics/claude-cli) installed and available in PATH
- Valid Claude API credentials configured
- Oh My Zsh installed
- [Kitty terminal](https://sw.kovidgoyal.net/kitty/) (optional - required for Alt+W and Alt+Q features)

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

---

## Kitty Terminal Features

The following features require the [Kitty terminal emulator](https://sw.kovidgoyal.net/kitty/) and provide advanced analysis capabilities by accessing the terminal's scrollback buffer.

### 5. What Went Wrong? (Alt+W)

Analyzes your terminal scrollback buffer to identify errors, warnings, and issues from recent command output.

**How to use:**
1. After encountering an error or unexpected behavior
2. Press `Alt+W`
3. Review the AI analysis of what went wrong
4. Get contextual explanations and potential solutions

**Examples:**

**Scenario:** Failed compilation with multiple errors
```bash
$ make build
gcc: error: undefined reference to 'main'
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1

# Press Alt+W
```

**Analysis:**
```
The compilation failed with a linker error. Analysis:

1. Missing main() function - The linker cannot find the program entry point
2. Architecture mismatch - Trying to link incompatible object files
3. The error occurred during the linking phase, not compilation

Suggested fixes:
- Ensure your source file includes a main() function
- Check that all object files are compiled for the same architecture
- Verify all required source files are included in the build
```

**Scenario:** Docker container failing to start
```bash
$ docker-compose up
ERROR: for webapp  Cannot start service webapp: driver failed
Error: failed to create shim: OCI runtime create failed
Container exited with code 137

# Press Alt+W
```

**Analysis:**
```
Docker container startup failed. Analysis:

1. Exit code 137 indicates the container was killed (128 + 9 = SIGKILL)
2. OCI runtime error suggests low-level container runtime issues
3. Common causes: insufficient memory, resource limits, or conflicts

Suggested fixes:
- Check available memory: docker stats
- Increase memory limits in docker-compose.yml
- Check for port conflicts with: netstat -tulpn
- Review container logs: docker logs webapp
```

**Scenario:** Python traceback in test output
```bash
$ pytest tests/
======== FAILURES ========
tests/test_api.py::test_login FAILED
Traceback (most recent call last):
  File "tests/test_api.py", line 45, in test_login
    assert response.status_code == 200
AssertionError: assert 401 == 200

# Press Alt+W
```

**Analysis:**
```
Test failure in authentication endpoint. Analysis:

1. Expected HTTP 200 (OK) but received 401 (Unauthorized)
2. The login endpoint is rejecting the credentials
3. This is an assertion error in test_login function

Possible causes:
- Test credentials are incorrect or expired
- Authentication service is not properly configured
- Database seeding might have failed
- Token generation logic has a bug

Next steps:
- Verify test fixtures and credentials in conftest.py
- Check if authentication service is running
- Review recent changes to login endpoint
- Add debug logging to see actual vs expected credentials
```

---

### 6. Quick Summary (Alt+Q)

Provides a concise summary of the current screen output, useful for understanding long command outputs or complex terminal sessions.

**How to use:**
1. After running a command with extensive output
2. Press `Alt+Q`
3. Get a brief summary of what's displayed on screen

**Examples:**

**Scenario:** Long test suite results
```bash
$ pytest tests/ -v
[hundreds of lines of test output]

# Press Alt+Q
```

**Summary:**
```
Test Results Summary:
- Total: 156 tests
- Passed: 142 (91%)
- Failed: 12 (8%)
- Skipped: 2 (1%)

Failed tests concentrated in:
- tests/test_database.py (8 failures)
- tests/test_api.py (4 failures)

Most common failure: Connection timeout to test database
```

**Scenario:** System resource overview
```bash
$ htop
[complex system monitor display]

# Press Alt+Q
```

**Summary:**
```
System Status:
- CPU: 8 cores, average 45% usage (cores 2 and 5 at 90%)
- Memory: 12.4GB / 16GB used (78%)
- Swap: 2.1GB / 8GB used
- Load average: 2.4, 2.1, 1.9

Top processes:
1. chrome (3.2GB RAM, 25% CPU)
2. python (1.8GB RAM, 15% CPU)
3. docker (890MB RAM, 8% CPU)

System is under moderate load, memory usage approaching limit.
```

**Scenario:** Git log analysis
```bash
$ git log --oneline -50
[50 commit entries]

# Press Alt+Q
```

**Summary:**
```
Recent Git Activity (last 50 commits):
- Timeframe: Last 2 weeks
- Primary focus: Authentication refactoring (18 commits)
- Bug fixes: 12 commits
- Feature additions: 15 commits
- Documentation: 5 commits

Main contributors:
- alice (28 commits)
- bob (15 commits)
- charlie (7 commits)

Latest significant change: "Implement OAuth2 integration" (3 hours ago)
```

---

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

### "This feature requires Kitty terminal" error

The Alt+W and Alt+Q features are only available in Kitty terminal:
- Install Kitty: https://sw.kovidgoyal.net/kitty/
- These features use Kitty's scrollback buffer API
- They will not work in other terminals (iTerm2, Alacritty, GNOME Terminal, etc.)
- All other plugin features (Alt+G, Alt+E, Alt+X, Alt+S) work in any terminal

## License

This plugin is provided as-is for personal and commercial use.

## Contributing

Contributions are welcome. Please ensure:
- Code follows existing style conventions
- Changes are tested with multiple natural language inputs
- Documentation is updated accordingly

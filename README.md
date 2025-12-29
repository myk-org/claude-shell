# Claude Shell

Natural language to shell command translation for Zsh using Claude AI.

## Overview

Claude Shell is an Oh My Zsh plugin that translates natural language queries into executable shell commands using Claude AI. Type what you want to do in plain English, press a keybinding, and get an accurate shell command ready to execute.

## Features

- **Instant Translation**: Convert natural language to shell commands with a single keystroke
- **Interactive Workflow**: Review and edit the suggested command before execution
- **Real-time Feedback**: Visual indicator while translation is in progress
- **Error Handling**: Gracefully handles failures and restores your original input
- **Clean Output**: Returns raw commands without markdown formatting or explanations

## Requirements

- [Claude CLI](https://github.com/anthropics/claude-cli) installed and available in PATH
- Valid Claude API credentials configured
- Oh My Zsh installed

## Installation

1. Clone this plugin into your Oh My Zsh custom plugins directory:

```bash
git clone <repository-url> ~/.oh-my-zsh/custom/plugins/claude-shell
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
source ~/.zshrc
```

## Usage

1. Type your natural language request on the command line
2. Press `Ctrl+G` to translate
3. Review the generated command
4. Press `Enter` to execute or edit as needed

### Keybinding

- **Ctrl+G** - Translate current buffer from natural language to shell command

## Examples

### File Operations

**Input:** `list all python files in current directory`
**Output:** `ls *.py`

**Input:** `find large files bigger than 100MB`
**Output:** `find . -type f -size +100M`

**Input:** `count lines in all shell scripts`
**Output:** `find . -name "*.sh" -exec wc -l {} +`

### System Information

**Input:** `show disk usage sorted by size`
**Output:** `du -sh * | sort -h`

**Input:** `list running docker containers`
**Output:** `docker ps`

**Input:** `check memory usage`
**Output:** `free -h`

### Text Processing

**Input:** `search for TODO in all python files`
**Output:** `grep -r "TODO" --include="*.py" .`

**Input:** `replace foo with bar in all text files`
**Output:** `find . -name "*.txt" -exec sed -i 's/foo/bar/g' {} +`

### Git Operations

**Input:** `show git log with graph for last 10 commits`
**Output:** `git log --graph --oneline -10`

**Input:** `undo last commit but keep changes`
**Output:** `git reset --soft HEAD~1`

## How It Works

1. The plugin captures your natural language query from the command buffer
2. Sends it to Claude CLI with a prompt optimized for command translation
3. Processes the response to ensure clean, executable output
4. Replaces the buffer with the translated shell command
5. Positions the cursor at the end for easy editing

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
- Check for keybinding conflicts: `bindkey | grep '\^G'`
- Try reloading your shell: `source ~/.zshrc`

## License

This plugin is provided as-is for personal and commercial use.

## Contributing

Contributions are welcome. Please ensure:
- Code follows existing style conventions
- Changes are tested with multiple natural language inputs
- Documentation is updated accordingly

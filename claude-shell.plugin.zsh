#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
# Claude Shell - Natural Language to Shell Command Translation
# ------------------------------------------------------------------------------
#
# Description:
#   This plugin provides a Zsh widget that translates natural language queries
#   into shell commands using Claude AI. It allows you to type what you want
#   to do in plain English and get a shell command suggestion.
#
# Usage:
#   1. Type your natural language request on the command line
#      Example: "list all python files in current directory"
#
#   2. Press Ctrl+G to translate to a shell command
#      Result: ls *.py
#
#   3. Review the command and press Enter to execute, or edit as needed
#
# Requirements:
#   - Claude CLI tool must be installed and available in PATH
#   - Proper Claude API credentials configured
#
# Keybinding:
#   Ctrl+G - Translate natural language to shell command
#
# Author: Custom Plugin
# ------------------------------------------------------------------------------

# Natural language to shell command widget using Claude
# Translates the current command line buffer from natural language to a shell command
claude-nl-to-shell() {
  # Return early if buffer is empty
  if [[ -z "$BUFFER" ]]; then
    return 0
  fi

  # Save the natural language query
  local nl_query="$BUFFER"

  # Show a temporary message while processing
  BUFFER="# Translating: $nl_query"
  zle -R

  # Translate to shell command using claude
  local shell_cmd
  shell_cmd=$(echo "$nl_query" | claude -p "Convert this to a shell command. Output ONLY the raw command. NO markdown formatting, NO code blocks, NO backticks, NO explanation, NO comments. Single line only. Just the plain command:" 2>/dev/null | sed 's/^```[a-z]*//;s/```$//' | tr -d '`' | tr -d '\n')

  # Check if claude command succeeded and returned non-empty output
  if [[ $? -eq 0 && -n "$shell_cmd" ]]; then
    # Strip leading/trailing whitespace
    shell_cmd="${shell_cmd##[[:space:]]}"
    shell_cmd="${shell_cmd%%[[:space:]]}"

    # Update buffer with the translated command
    BUFFER="$shell_cmd"
  else
    # On error, restore original buffer
    BUFFER="$nl_query"
    # Show error message briefly
    zle -M "Error: Claude translation failed"
  fi

  # Move cursor to end of line
  CURSOR=${#BUFFER}
  zle -R
}

# Register the widget and bind to Ctrl+G
zle -N claude-nl-to-shell
bindkey '^g' claude-nl-to-shell

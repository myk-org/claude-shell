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
#   Alt+G: Natural Language to Shell
#     1. Type your natural language request: "list all python files"
#     2. Press Alt+G to translate: ls *.py
#     3. Review and execute or edit as needed
#
#   Alt+E: Explain Command
#     1. Type or have a command in the buffer: find . -type f -name "*.py"
#     2. Press Alt+E to see an explanation below the prompt
#     3. Buffer remains unchanged
#
#   Alt+X: Fix Last Error
#     1. Run a command that fails
#     2. Press Alt+X to get a suggested fix
#     3. Review the corrected command and execute
#
#   Alt+S: Search History
#     1. Type a natural language search query: "docker commands"
#     2. Press Alt+S to find the most relevant command from history
#     3. Review and execute the found command
#
# Requirements:
#   - Claude CLI tool must be installed and available in PATH
#   - Proper Claude API credentials configured
#
# Keybindings:
#   Alt+G - Translate natural language to shell command
#   Alt+E - Explain current command
#   Alt+X - Fix last failed command
#   Alt+S - Search command history with natural language
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

  # Show a processing message
  zle -M "Processing: $nl_query"
  zle -R  # Force immediate redraw

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

# Explain command widget
# Shows an explanation of the current command in the buffer
claude-explain-command() {
  # Return early if buffer is empty
  if [[ -z "$BUFFER" ]]; then
    zle -M "No command to explain"
    return 0
  fi

  # Save the command to explain
  local cmd_to_explain="$BUFFER"

  # Show processing message
  zle -M "Explaining command..."
  zle -R  # Force immediate redraw

  # Get explanation from Claude
  local explanation
  explanation=$(echo "$cmd_to_explain" | claude -p "Explain this shell command concisely. What does each part do? Be brief and clear." 2>/dev/null)

  # Check if claude command succeeded
  if [[ $? -eq 0 && -n "$explanation" ]]; then
    # Strip markdown code blocks and extra whitespace
    explanation=$(echo "$explanation" | sed 's/^```[a-z]*//;s/```$//' | tr -d '`')
    # Display explanation (zle -M shows multi-line messages)
    zle -M "$explanation"
  else
    zle -M "Error: Could not get explanation from Claude"
  fi

  # Buffer remains unchanged
  zle -R
}

# Fix last error widget
# Captures the last failed command and suggests a fix
claude-fix-error() {
  # Get the last command from history
  local last_cmd
  last_cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')

  # Return early if no history
  if [[ -z "$last_cmd" ]]; then
    zle -M "No previous command found"
    return 0
  fi

  # Show processing message
  zle -M "Analyzing error for: $last_cmd"
  zle -R  # Force immediate redraw

  # Get fix suggestion from Claude
  local fixed_cmd
  fixed_cmd=$(echo "$last_cmd" | claude -p "This command failed. Suggest a fix. Output ONLY the corrected command, no explanation, no markdown, no code blocks, no backticks. Just the plain command:" 2>/dev/null | sed 's/^```[a-z]*//;s/```$//' | tr -d '`' | tr -d '\n')

  # Check if claude command succeeded
  if [[ $? -eq 0 && -n "$fixed_cmd" ]]; then
    # Strip leading/trailing whitespace
    fixed_cmd="${fixed_cmd##[[:space:]]}"
    fixed_cmd="${fixed_cmd%%[[:space:]]}"

    # Update buffer with the fixed command
    BUFFER="$fixed_cmd"
    CURSOR=${#BUFFER}
  else
    zle -M "Error: Could not get fix suggestion from Claude"
  fi

  zle -R
}

# History search widget
# Searches command history using natural language
claude-history-search() {
  # Return early if buffer is empty
  if [[ -z "$BUFFER" ]]; then
    zle -M "No search query provided"
    return 0
  fi

  # Save the search query
  local search_query="$BUFFER"

  # Get recent history (last 100 commands)
  local history_context
  history_context=$(fc -ln -100 2>/dev/null | sed 's/^[[:space:]]*//')

  # Return early if no history
  if [[ -z "$history_context" ]]; then
    zle -M "No command history available"
    return 0
  fi

  # Show processing message
  zle -M "Searching history for: $search_query"
  zle -R  # Force immediate redraw

  # Search history using Claude
  local found_cmd
  found_cmd=$(echo "Search query: $search_query\n\nCommand history:\n$history_context" | claude -p "Search this command history for the query provided. Return ONLY the single most relevant command, no explanation, no markdown, no code blocks, no backticks. Just the plain command:" 2>/dev/null | sed 's/^```[a-z]*//;s/```$//' | tr -d '`' | tr -d '\n')

  # Check if claude command succeeded
  if [[ $? -eq 0 && -n "$found_cmd" ]]; then
    # Strip leading/trailing whitespace
    found_cmd="${found_cmd##[[:space:]]}"
    found_cmd="${found_cmd%%[[:space:]]}"

    # Update buffer with the found command
    BUFFER="$found_cmd"
    CURSOR=${#BUFFER}
  else
    # Restore original buffer on error
    zle -M "Error: Could not search history with Claude"
  fi

  zle -R
}

# Register all widgets
zle -N claude-nl-to-shell
zle -N claude-explain-command
zle -N claude-fix-error
zle -N claude-history-search

# Bind to Alt+ keys (^[ is the escape sequence for Alt)
bindkey '^[g' claude-nl-to-shell      # Alt+G
bindkey '^[e' claude-explain-command   # Alt+E
bindkey '^[x' claude-fix-error         # Alt+X
bindkey '^[s' claude-history-search    # Alt+S

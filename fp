#!/bin/bash

# Parse command line arguments
while getopts "clv" opt; do
  case ${opt} in
    c )
      editor="code"
      ;;
    v )
      editor="nvim"
      ;;
    l )
      editor="lvim"
      ;;
    \? )
      echo "Usage: cd_proj [-c | -l | -v]" >&2
      exit 1
      ;;
  esac
done

# Set the directories to search for subdirectories
dirs=(~/projects/main ~/projects/side ~/projects/course)

# Use fzf to search for subdirectories one level deep in each directory
selected_dir=$(find "${dirs[@]}" -maxdepth 1 -type d | tail -n +2 | fzf)

echo "Selected directory: $selected_dir"
# If a directory is selected, cd into it and optionally open with editor
if [[ -n "$selected_dir" ]]; then
  cd "$(realpath "$selected_dir")"
  if [[ -n "$editor" ]]; then
    $editor .
  fi
fi
exec zsh


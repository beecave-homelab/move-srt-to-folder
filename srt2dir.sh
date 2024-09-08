#!/bin/bash
set -euo pipefail

# Script Description: Moves .srt files to matching directories based on the file name.
# Script Name: srt2dir.sh
# Author: elvee
# Version: 1.1.0
# License: MIT
# Creation Date: 09/09/2024
# Last Modified: 09/09/2024
# Usage: ./srt2dir.sh [-d DIRECTORY] [-sd SRT_DIRECTORY] [-r] [--dry-run]

# ASCII Art
print_ascii_art() {
  echo "
  
███████ ██████  ████████ ██████  ██████  ██ ██████  
██      ██   ██    ██         ██ ██   ██ ██ ██   ██ 
███████ ██████     ██     █████  ██   ██ ██ ██████  
     ██ ██   ██    ██    ██      ██   ██ ██ ██   ██ 
███████ ██   ██    ██    ███████ ██████  ██ ██   ██                                                     
                                                   
  "
}

# Function to display help
show_help() {
  echo "
Usage: $0 [OPTIONS]

Options:
  -d, --directory DIRECTORY        Specify the root directory to scan for folders (default: current directory)
  -sd, --srt-directory SRT_DIR     Specify the directory to scan for .srt files (default: same as the folder directory)
  -r, --recursive                  Recursively search for .srt files in subdirectories
  -dr, --dry-run                   Perform a dry run without moving files. Shows found matches.
  -h, --help                       Show this help message

Examples:
  $0 -d /path/to/root_directory -sd /path/to/srt_directory
  $0 -r --dry-run
"
}

# Function for error handling
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

# Function to list .srt files with matching directories
find_and_list_srt_files() {
  local folder_dir="$1"
  local srt_dir="$2"
  local recursive_flag="$3"
  
  # Define the search command for .srt files
  if [[ "$recursive_flag" == true ]]; then
    srt_files=$(find "$srt_dir" -maxdepth 100 -type f -name "*.srt")
  else
    srt_files=$(find "$srt_dir" -maxdepth 1 -type f -name "*.srt")
  fi

  # Loop through found .srt files and check if matching folder exists
  declare -a matched_files=()
  for srt_file in $srt_files; do
    base_name=$(basename "$srt_file" .srt)
    target_dir="$folder_dir/$base_name"
    
    if [[ -d "$target_dir" ]]; then
      matched_files+=("$srt_file -> $target_dir")
    fi
  done

  # Check if the array has elements before returning or printing
  if [[ ${#matched_files[@]} -eq 0 ]]; then
    echo "No matching .srt files found."
  else
    echo "${matched_files[@]}"
  fi
}

# Confirmation step before moving files
confirm_move() {
  read -p "Do you want to move the matched files? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then
    echo "Operation cancelled."
    exit 0
  fi
}

# Move .srt files to their corresponding directories
move_srt_files() {
  local folder_dir="$1"
  local srt_dir="$2"
  local recursive_flag="$3"

  matched_files=$(find_and_list_srt_files "$folder_dir" "$srt_dir" "$recursive_flag")

  # If dry run is enabled, just output the results
  if [[ "$DRY_RUN" == true ]]; then
    if [[ -z "$matched_files" ]]; then
      echo "No matching .srt files found."
    else
      echo "Dry run: These files would be moved:"
      echo "$matched_files"
    fi
    return
  fi

  # Show matched files and confirm before moving
  if [[ -n "$matched_files" ]]; then
    echo "Found the following .srt files with matching folders:"
    echo "$matched_files"
    
    confirm_move

    # Proceed with moving the files
    while IFS= read -r match; do
      srt_file=$(echo "$match" | cut -d " " -f 1)
      target_dir=$(echo "$match" | cut -d " " -f 3)

      echo "Moving: $srt_file -> $target_dir/"
      mv "$srt_file" "$target_dir/"
    done <<< "$matched_files"
    echo "Files moved successfully."
  else
    echo "No matching .srt files found."
  fi
}

# Main function to parse arguments and execute logic
main() {
  # Define default directory as the current working directory
  local folder_directory="${PWD}"
  local srt_directory="${PWD}"  # Default to the same directory as the folders

  # Initialize recursive and dry-run options
  RECURSIVE=false
  DRY_RUN=false

  # Parse command-line options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d|--directory)
        folder_directory="$2"
        shift 2
        ;;
      -sd|--srt-directory)
        srt_directory="$2"
        shift 2
        ;;
      -r|--recursive)
        RECURSIVE=true
        shift
        ;;
      -dr|--dry-run)
        DRY_RUN=true
        shift
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      *)
        error_exit "Invalid option: $1"
        ;;
    esac
  done

  # Check if the specified directories exist
  if [[ ! -d "$folder_directory" ]]; then
    error_exit "The specified folder directory does not exist: $folder_directory"
  fi

  if [[ ! -d "$srt_directory" ]]; then
    error_exit "The specified .srt directory does not exist: $srt_directory"
  fi

  # Execute the file movement logic
  move_srt_files "$folder_directory" "$srt_directory" "$RECURSIVE"
}

# Print ASCII Art
print_ascii_art

# Execute the main function
main "$@"

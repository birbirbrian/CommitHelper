#!/bin/bash

# Function to read user input with a specified maximum word count
read_input() {
  local prompt="$1"
  local max_words="$2"
  local input
  while true; do
    read -p "$prompt" -r input
    # Count words using wc and awk
    local word_count=$(echo "$input" | wc -w | awk '{print $1}')
    if [ "$word_count" -le "$max_words" ]; then
      echo "$input"
      break
    else
      echo "Input exceeds the maximum word count ($max_words words). Please try again."
    fi
  done
}

# Display commit type options
echo "Select a commit type:"
echo "1. NEW — A new feature"
echo "2. BUG FIX — A bug fix"
echo "3. WORKAROUND — A workaround solution"
echo "4. UPDATE — A adjustment but not affect the original code"


# Read user choice
read -p "Enter the number corresponding to your commit type: " choice

case "$choice" in
  1)
    commit_type="NEW"
    ;;
  2)
    commit_type="BUG FIX"
    ;;
  3)
    commit_type="WORKAROUND"
    ;;
  4)
    commit_type="UPDATE"
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

# Ask the user to enter the project name
echo "Enter the project name:"
project=$(read_input "" 50)

# Ask the user to enter the module
echo "Enter the module:"
module=$(read_input "" 50)

# Ask the user to enter the main_message
echo "Enter the main message:"
main_message=$(read_input "" 200)

# Ask the user to enter the description
echo "Enter DESCRIPTION:"
description=$(read_input "" 200)

# Ask the user to enter the impact_project
echo "Enter IMPACT PROJECTS:"
impact_project=$(read_input "" 200)

# Ask the user to enter the test
echo "Enter TEST:"
test=$(read_input "" 200)

# Generate the Git commit message
commit_message="[$commit_type] $project: $module: $main_message

[DESCRIPTION]
$description

[IMPACT PROJECTS]
$impact_project

[TEST]
$test"

# Display the Git commit message with the commit type label
echo "========================================"
echo "Generated Git commit message:"
echo -e "$commit_message"

# Create a temporary file to store the commit message
temp_file=$(mktemp)
echo -e "$commit_message" > "$temp_file"

# Create the Git commit using the temporary file
git commit -q -F "$temp_file"

# Clean up the temporary file
rm "$temp_file"

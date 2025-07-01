#!/bin/bash

# Display usage information
usage() {
    echo "Usage: $0 <start_hash> <end_hash>"
    echo "  <start_hash>: hash of the starting commit"
    echo "  <end_hash>: hash of the ending commit"
    exit 1
}

# Get the list of commits between two given hashes
get_commit_list() {
    git rev-list --ancestry-path "$1".."$2"
}

# Find and display the midpoint commit(s)
find_midpoint_commits() {
    local start_hash="$1"
    local end_hash="$2"
    local commits=($(get_commit_list "$start_hash" "$end_hash"))
    local count=${#commits[@]}

    echo "Total number of commits: $count"

    if [ $count -eq 0 ]; then
        echo "No commits found between the specified hashes."
        return
    fi

    local mid=$((count / 2))
    if [ $((count % 2)) -eq 0 ]; then
        echo "There are two midpoint commits:"
        echo "${commits[$((mid-1))]}"
        echo "${commits[$mid]}"
    else
        echo "There is one midpoint commit:"
        echo "${commits[$mid]}"
    fi
}

# Check the number of arguments
if [ $# -ne 2 ]; then
    usage
fi

# Verify if the arguments are valid Git commit hashes
if ! git rev-parse --quiet --verify "$1^{commit}" >/dev/null 2>&1 || 
   ! git rev-parse --quiet --verify "$2^{commit}" >/dev/null 2>&1; then
    echo "Error: Invalid commit hash specified."
    usage
fi

# Execute the main function
find_midpoint_commits "$1" "$2"

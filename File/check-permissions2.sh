#!/bin/bash

DIRS=(
    "/usr/bin"
)

# Loop through each directory in the array
for dir in "${DIRS[@]}"; do
    # Use globbing (*) to list files in the directory
    # This will capture the output of ls -l "$dir" in an array
    DIRS_FILES=("$dir"/*)

    for file in "${DIRS_FILES[@]}"; do
        # Get just the filename from the full path
        filename=$(basename "$file")

        if [[ "$filename" == "bash" ]]; then
            # Use stat to get file permissions and modification time
            FILE_PERM=$(stat "$file")
            echo "$FILE_PERM"

            # Use grep to filter for the line starting with "Modify:"
            GREP_MODIFY=$(echo "$FILE_PERM" | grep "^Modify:")
            echo "$GREP_MODIFY"
        fi
    done
done

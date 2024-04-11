#!/bin/bash

#                    File/check-permissions.sh
#                    should be run as root
#                    Author: @eto330
#
#
#
#


# Check for root privileges (adjust as needed)
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

# Define directories array (adjust paths as needed)
DIRS=(
  "/usr/bin/"
  # Add more directories as needed
)

# Define secure permissions (adjust as needed)
SECURE_PERMISSIONS="755"

declare -a BAD_FILES

# Loop through each directory in the DIRS array
for dir in "${DIRS[@]}"; do
  # Check if directory exists and is readable
  if [[ -d "$dir" && -r "$dir" ]]; then
    # Find all files wihi the current directory (recursive)
    while IFS= read -r -d '' filename; do
      PERM=$(stat --format="%a" "$filename" 2>/dev/null)
      if [[ $? -eq 0 && "$PERM" != "$SECURE_PERMISSIONS" ]]; then
        BAD_FILES+=("$filename")
      fi
    done < <(find "$dir" -type f -print0)
  else
    echo "Warning: Directory '$dir' does not exist or is not accessible."
  fi
done

# Check if there are bad files with wrong permissions
if [[ "${#BAD_FILES[@]}" -eq 0 ]]; then
  echo "There are no files with bad permissions in the specified directories."
else
  echo "The following files have bad permissions:"
  for filename in "${BAD_FILES[@]}"; do
    echo "$filename"
  done
fi

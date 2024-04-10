#!/usr/bin/bash







LAST_MODIFIED=$(stat --format="%a" "./README.md" 2>/dev/null) 

echo "$LAST_MODIFIED"




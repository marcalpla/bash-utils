#!/bin/bash
# Simple script to grep logs

PATTERN=exception\\\|"not exist" # Search 'exception' or 'not exist'
PREV_LINES=5
NEXT_LINES=5

echo "Files containing '$PATTERN':"
echo ""

grep -l -i "$PATTERN" * --exclude=$(basename $0)

echo ""
echo "Lines containing '$PATTERN':"
echo ""

grep -A $PREV_LINES -B $NEXT_LINES -n -i "$PATTERN" * --exclude=$(basename $0) --color=auto

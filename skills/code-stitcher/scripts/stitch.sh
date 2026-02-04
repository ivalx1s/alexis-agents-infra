#!/bin/zsh
# Wrapper for CodeStitcher
# Usage: ./stitch.sh <source_dir> <output_file>
#
# Example:
#   ./stitch.sh /path/to/.task-board /path/to/.task-board/.temp/board.txt

SCRIPT_DIR="${0:A:h}"
CODE_STITCHER_DIR="$SCRIPT_DIR/code-stitcher"

if [[ $# -lt 2 ]]; then
    echo "Usage: stitch.sh <source_dir> <output_file>"
    echo "Example: stitch.sh .task-board .task-board/.temp/board.txt"
    exit 1
fi

SOURCE_DIR="$1"
OUTPUT_FILE="$2"

# Ensure output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

cd "$CODE_STITCHER_DIR" && swift run CodeStitcher -- \
    mode:read \
    source:"$SOURCE_DIR" \
    destination:"$OUTPUT_FILE"

echo "Stitched to: $OUTPUT_FILE"

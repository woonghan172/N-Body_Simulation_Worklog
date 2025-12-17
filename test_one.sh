#!/bin/bash

set -e

# -------- Argument Parsing --------
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Usage: $0 [strategy] [test-case-number] [optional-output-file]"
    echo "Strategies:"
    echo "  0 : serial"
    echo "  1 : shared_memory"
    echo "  2 : thread_coarsening"
    echo "  3 : optimal"
    echo "  4 : hierarchical"
    exit 1
fi

STRATEGY=$1
TEST_NUM=$2
USER_OUTPUT=$3

# -------- Strategy Selection --------
case $STRATEGY in
    0)
        EXEC="./build/serial"
        STRATEGY_NAME="serial"
        ;;
    1)
        EXEC="./build/shared_memory"
        STRATEGY_NAME="shared_memory"
        ;;
    2)
        EXEC="./build/thread_coarsening"
        STRATEGY_NAME="thread_coarsening"
        ;;
    3)
        EXEC="./build/optimal"
        STRATEGY_NAME="optimal"
        ;;
    4)
        EXEC="./build/hierarchical"
        STRATEGY_NAME="hierarchical"
        ;;
    *)
        echo "[ERROR] Invalid strategy: $STRATEGY"
        exit 1
        ;;
esac

# -------- Input Test Files --------
MASS_FILE="./tests/correctness/testin${TEST_NUM}_mass.txt"
COORD_FILE="./tests/correctness/testin${TEST_NUM}_coordinate.txt"

if [ ! -f "$MASS_FILE" ]; then
    echo "[ERROR] Mass file not found: $MASS_FILE"
    exit 1
fi

if [ ! -f "$COORD_FILE" ]; then
    echo "[ERROR] Coordinate file not found: $COORD_FILE"
    exit 1
fi

# -------- Determine Output File --------
if [ -z "$USER_OUTPUT" ]; then
    RESULTS_DIR="./results"

    # Create results directory if missing
    if [ ! -d "$RESULTS_DIR" ]; then
        echo "[INFO] Creating results directory at $RESULTS_DIR"
        mkdir "$RESULTS_DIR"
    fi

    OUTPUT_FILE="${RESULTS_DIR}/${STRATEGY_NAME}_test${TEST_NUM}.txt"
else
    OUTPUT_FILE="$USER_OUTPUT"
fi

# -------- Run the Program --------
echo "[INFO] Executing:"
echo "       $EXEC"
echo "       Mass file      : $MASS_FILE"
echo "       Coordinate file: $COORD_FILE"
echo "       Output file    : $OUTPUT_FILE"
echo

$EXEC "$MASS_FILE" "$COORD_FILE" "$OUTPUT_FILE"

echo "[INFO] Done."

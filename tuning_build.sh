#!/bin/bash

set -e  # stop on any error

BUILD_DIR="build"
CU_DIR="cu_files"

# 1. Create build directory or clear it
if [ -d "$BUILD_DIR" ]; then
    echo "[INFO] build/ exists. Clearing contents..."
    rm -rf "$BUILD_DIR"/*
else
    echo "[INFO] Creating build/ directory..."
    mkdir "$BUILD_DIR"
fi

# 2. List of CUDA source files to compile
CU_FILES=(
    "optimal.cu"
)

echo "[INFO] Compiling CUDA files..."

# Compile each file
for cu in "${CU_FILES[@]}"; do
    src="${CU_DIR}/${cu}"
    exe="${BUILD_DIR}/${cu%.cu}"   # remove .cu extension
    echo "  → nvcc $src -o $exe"
    nvcc -O3 -arch=sm_75 "$src" -o "$exe"
done

echo "Build success for current iteration, running speedup tests..."

EXEC="./build/optimal"

MASS_FILE0="./tests/speedup/s_testin0_mass.txt"
COORD_FILE0="./tests/speedup/s_testin0_coordinate.txt"
OUTPUT_FILE0="./tests/speedup/s_testout0.txt"

MASS_FILE1="./tests/speedup/s_testin1_mass.txt"
COORD_FILE1="./tests/speedup/s_testin1_coordinate.txt"
OUTPUT_FILE1="./tests/speedup/s_testout1.txt"

MASS_FILE2="./tests/speedup/s_testin2_mass.txt"
COORD_FILE2="./tests/speedup/s_testin2_coordinate.txt"
OUTPUT_FILE2="./tests/speedup/s_testout2.txt"

echo "Executing N=100,000 Test"
$EXEC "$MASS_FILE0" "$COORD_FILE0" "$OUTPUT_FILE0"

echo "Executing N=500,000 Test"
$EXEC "$MASS_FILE1" "$COORD_FILE1" "$OUTPUT_FILE1"

echo "Executing N=1,000,000 Test"
$EXEC "$MASS_FILE2" "$COORD_FILE2" "$OUTPUT_FILE2"
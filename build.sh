#!/bin/bash

# Define the build directory
BUILD_DIR="build"

# Define the target directory for binaries
TARGET_DIR="bin"

# Function to clean object files and intermediate build artifacts
clean() {
	local config = "$1"
	echo $config
    echo "Cleaning old object files and intermediate build artifacts..."
    find "$BUILD_DIR" -type f -name '*.o' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.obj' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.a' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.lib' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.dll' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.so' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.dylib' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.exe' -delete 2>/dev/null
    find "$BUILD_DIR" -type f -name '*.d' -delete 2>/dev/null

    if [ -d "$BUILD_DIR" ]; then
        find "$BUILD_DIR" -type d -exec rm -rf {} +
    fi

    if [ -d "$TARGET_DIR" ]; then
        find "$TARGET_DIR" -type d -exec rm -rf {} +
    fi
}

# Function to generate build files with Premake
generate_build_files() {
    echo "Generating build files with Premake..."
    premake5 gmake2
}

# Function to build the project using make
build() {
    CONFIG=${1:-debug}
    echo "Building the project with configuration: $CONFIG"
    cd "$BUILD_DIR" || exit
    make config="$CONFIG"
}

# Main script logic
if [ "$1" == "clean" ]; then
    clean
    exit 0
elif [ "$1" == "debug" ] || [ "$1" == "release" ]; then
    clean
    generate_build_files
    build "$1"
else
    clean
    generate_build_files
    build "debug"
fi

echo

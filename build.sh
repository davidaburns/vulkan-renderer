#!/bin/bash

# Define the build directory
BUILD_DIR="build"

# Define the target directory for binaries
TARGET_DIR="bin"

# Function to clean object files and intermediate build artifacts
clean() {
	echo "Cleaning old object files and intermediate build artifacts..."
	make clean
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
    make all config="$CONFIG" VERBOSE=1
}

# Main script logic
if [ "$1" == "clean" ]; then
    clean
    exit 0
elif [ "$1" == "debug" ] || [ "$1" == "release" ]; then
    generate_build_files
    build "$1"
else
    generate_build_files
    build "debug"
fi

echo

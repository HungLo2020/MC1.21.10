#!/bin/bash

################################################################################
# Simple Minecraft 1.21.10 Client JAR Downloader
################################################################################
# This script only downloads the Minecraft client JAR without decompiling.
# Use this if you want to manually decompile or if the full script fails.
#
# After downloading, you can:
#   1. Run: ./gradlew genSources
#   2. Run: ./gradlew extractMinecraftSources
#
# Prerequisites:
# - Network access to launchermeta.mojang.com and piston-data.mojang.com
# - curl or wget
################################################################################

set -e

echo "========================================================================"
echo "Minecraft 1.21.10 Client JAR Downloader"
echo "========================================================================"
echo ""

# Configuration
MC_VERSION="1.21.10"
VERSION_MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest_v2.json"
OUTPUT_DIR="."
OUTPUT_FILE="minecraft-client-${MC_VERSION}.jar"

# Check for download tool
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -L -o"
    DOWNLOAD_STDOUT="curl -s"
    echo "Using curl for downloads"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -O"
    DOWNLOAD_STDOUT="wget -q -O -"
    echo "Using wget for downloads"
else
    echo "ERROR: Neither curl nor wget is installed"
    exit 1
fi

echo ""
echo "Step 1: Fetching version manifest..."

# Download and parse version manifest
VERSION_URL=$($DOWNLOAD_STDOUT "$VERSION_MANIFEST_URL" | grep -o '"id":"'$MC_VERSION'"' -A 5 | grep '"url":' | head -1 | sed 's/.*"url":"\([^"]*\)".*/\1/')

if [ -z "$VERSION_URL" ]; then
    echo "ERROR: Could not find Minecraft $MC_VERSION"
    exit 1
fi

echo "Found version URL"
echo ""
echo "Step 2: Fetching version metadata..."

# Download and parse version metadata
CLIENT_URL=$($DOWNLOAD_STDOUT "$VERSION_URL" | grep -A 2 '"client":' | grep '"url":' | head -1 | sed 's/.*"url":"\([^"]*\)".*/\1/')

if [ -z "$CLIENT_URL" ]; then
    echo "ERROR: Could not find client download URL"
    exit 1
fi

echo "Found client JAR URL"
echo ""
echo "Step 3: Downloading Minecraft client JAR..."
echo "URL: $CLIENT_URL"
echo "Output: $OUTPUT_FILE"
echo ""

# Download client JAR
if ! $DOWNLOAD_CMD "$OUTPUT_FILE" "$CLIENT_URL"; then
    echo "ERROR: Failed to download client JAR"
    exit 1
fi

if [ ! -f "$OUTPUT_FILE" ] || [ ! -s "$OUTPUT_FILE" ]; then
    echo "ERROR: Downloaded file is missing or empty"
    exit 1
fi

FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
echo ""
echo "========================================================================"
echo "SUCCESS! Downloaded Minecraft $MC_VERSION client JAR"
echo "========================================================================"
echo ""
echo "File: $OUTPUT_FILE"
echo "Size: $FILE_SIZE"
echo ""
echo "Next steps:"
echo "  1. Run: ./gradlew genSources"
echo "  2. Run: ./gradlew extractMinecraftSources"
echo ""
echo "Or use the full automation script:"
echo "  ./download-and-decompile-client.sh"
echo ""

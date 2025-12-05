#!/bin/bash

################################################################################
# Minecraft 1.21.10 Client Source Code Download and Decompilation Script
################################################################################
# This script downloads the Minecraft 1.21.10 client JAR and decompiles it
# using Fabric Loom's genSources task to generate both client and server code.
#
# Prerequisites:
# - Network access to:
#   * launchermeta.mojang.com
#   * piston-data.mojang.com  
#   * maven.fabricmc.net
# - Java 21+ installed
# - curl or wget available
#
# Usage:
#   ./download-and-decompile-client.sh
################################################################################

set -e  # Exit on error

echo "========================================================================"
echo "Minecraft 1.21.10 Client Source Decompilation"
echo "========================================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MC_VERSION="1.21.10"
VERSION_MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest_v2.json"
TEMP_DIR="./temp-decompile"

echo -e "${BLUE}Step 1: Checking prerequisites...${NC}"
echo ""

# Check for Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}ERROR: Java is not installed or not in PATH${NC}"
    echo "Please install Java 21 or higher"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}' | awk -F '.' '{print $1}')
echo "Found Java version: $JAVA_VERSION"
if [ "$JAVA_VERSION" -lt 21 ]; then
    echo -e "${YELLOW}WARNING: Java 21+ is recommended. You have Java $JAVA_VERSION${NC}"
fi

# Check for curl or wget
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -L -o"
    DOWNLOAD_STDOUT="curl -s"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -O"
    DOWNLOAD_STDOUT="wget -q -O -"
else
    echo -e "${RED}ERROR: Neither curl nor wget is installed${NC}"
    echo "Please install curl or wget"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites check passed${NC}"
echo ""

# Create temp directory
mkdir -p "$TEMP_DIR"

echo -e "${BLUE}Step 2: Fetching Minecraft version manifest...${NC}"
echo ""

# Download version manifest
if ! $DOWNLOAD_STDOUT "$VERSION_MANIFEST_URL" > "$TEMP_DIR/version_manifest.json"; then
    echo -e "${RED}ERROR: Failed to download version manifest${NC}"
    echo "Please check your network connection and access to launchermeta.mojang.com"
    exit 1
fi

# Extract version URL for 1.21.10
# Using Python for reliable JSON parsing
if command -v python3 &> /dev/null; then
    VERSION_URL=$(python3 -c "
import json, sys
try:
    with open('$TEMP_DIR/version_manifest.json', 'r') as f:
        data = json.load(f)
    for version in data.get('versions', []):
        if version.get('id') == '$MC_VERSION':
            print(version.get('url', ''))
            sys.exit(0)
    sys.exit(1)
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)
" 2>/dev/null)
else
    # Fallback to grep/sed (less reliable but works if no Python)
    VERSION_URL=$(grep -A 10 "\"id\".*:.*\"$MC_VERSION\"" "$TEMP_DIR/version_manifest.json" | grep '"url"' | head -1 | sed 's/.*"url"[^"]*"\([^"]*\)".*/\1/')
fi

if [ -z "$VERSION_URL" ]; then
    echo -e "${RED}ERROR: Could not find Minecraft $MC_VERSION in version manifest${NC}"
    echo ""
    echo "This could mean:"
    echo "  1. Version $MC_VERSION doesn't exist (typo?)"
    echo "  2. Mojang's manifest format changed"
    echo "  3. Network/parsing issue"
    echo ""
    echo "Debug: Checking available versions..."
    if command -v python3 &> /dev/null; then
        python3 -c "
import json
with open('$TEMP_DIR/version_manifest.json', 'r') as f:
    data = json.load(f)
print('Recent versions:')
for v in data.get('versions', [])[:10]:
    print(f\"  - {v.get('id')} ({v.get('type')})\")
" 2>/dev/null || echo "Could not parse manifest"
    else
        echo "Install Python3 for better debugging"
        grep -o '"id":"[^"]*"' "$TEMP_DIR/version_manifest.json" | head -10
    fi
    exit 1
fi

echo "Found version URL: $VERSION_URL"
echo ""

echo -e "${BLUE}Step 3: Downloading version metadata...${NC}"
echo ""

# Download version metadata
if ! $DOWNLOAD_STDOUT "$VERSION_URL" > "$TEMP_DIR/version.json"; then
    echo -e "${RED}ERROR: Failed to download version metadata${NC}"
    exit 1
fi

# Extract client download URL
if command -v python3 &> /dev/null; then
    CLIENT_URL=$(python3 -c "
import json
try:
    with open('$TEMP_DIR/version.json', 'r') as f:
        data = json.load(f)
    print(data.get('downloads', {}).get('client', {}).get('url', ''))
except Exception:
    pass
" 2>/dev/null)
else
    # Fallback
    CLIENT_URL=$(grep -A 5 '"client"' "$TEMP_DIR/version.json" | grep '"url"' | head -1 | sed 's/.*"url"[^"]*"\([^"]*\)".*/\1/')
fi

if [ -z "$CLIENT_URL" ]; then
    echo -e "${RED}ERROR: Could not find client download URL in version metadata${NC}"
    exit 1
fi

echo "Found client JAR URL: $CLIENT_URL"
echo ""

echo -e "${BLUE}Step 4: Downloading Minecraft client JAR...${NC}"
echo ""
echo "This may take a few minutes depending on your connection..."
echo ""

CLIENT_JAR="$TEMP_DIR/minecraft-client-$MC_VERSION.jar"

if ! $DOWNLOAD_CMD "$CLIENT_JAR" "$CLIENT_URL"; then
    echo -e "${RED}ERROR: Failed to download client JAR${NC}"
    echo "Please check your network connection and access to piston-data.mojang.com"
    exit 1
fi

if [ ! -f "$CLIENT_JAR" ] || [ ! -s "$CLIENT_JAR" ]; then
    echo -e "${RED}ERROR: Client JAR was not downloaded properly${NC}"
    exit 1
fi

CLIENT_SIZE=$(du -h "$CLIENT_JAR" | cut -f1)
echo -e "${GREEN}✓ Downloaded client JAR successfully ($CLIENT_SIZE)${NC}"
echo ""

echo -e "${BLUE}Step 5: Running Fabric Loom genSources to decompile...${NC}"
echo ""
echo "This will take 5-15 minutes depending on your system..."
echo "Fabric Loom will:"
echo "  1. Download necessary dependencies"
echo "  2. Apply Mojang official mappings"
echo "  3. Decompile both client and server code"
echo "  4. Generate readable Java source files"
echo ""

# Run Gradle genSources task
if ! ./gradlew genSources --no-daemon --stacktrace; then
    echo -e "${RED}ERROR: Failed to run genSources task${NC}"
    echo ""
    echo "This usually means:"
    echo "  1. Network access to maven.fabricmc.net is blocked"
    echo "  2. Java version is incompatible"
    echo "  3. Gradle cache is corrupted"
    echo ""
    echo "Troubleshooting:"
    echo "  - Ensure maven.fabricmc.net is accessible"
    echo "  - Try: ./gradlew clean --no-daemon"
    echo "  - Try: rm -rf .gradle/loom-cache"
    exit 1
fi

echo -e "${GREEN}✓ Source generation completed successfully${NC}"
echo ""

echo -e "${BLUE}Step 6: Extracting decompiled sources to repository...${NC}"
echo ""

# Run the custom extraction task
if ! ./gradlew extractMinecraftSources --no-daemon; then
    echo -e "${RED}ERROR: Failed to extract Minecraft sources${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Sources extracted successfully${NC}"
echo ""

echo -e "${BLUE}Step 7: Updating MOVETHIS folder with client sources...${NC}"
echo ""

# Copy sources to MOVETHIS folder as well
if [ -d "net/minecraft/client" ]; then
    echo "Copying client sources to MOVETHIS folder..."
    cp -r net/minecraft/client MOVETHIS/net/minecraft/
    echo -e "${GREEN}✓ Client sources copied to MOVETHIS/net/minecraft/client/${NC}"
else
    echo -e "${YELLOW}WARNING: Client sources directory not found at net/minecraft/client${NC}"
    echo "Checking for sources in other locations..."
fi

echo ""
echo -e "${BLUE}Step 8: Verification...${NC}"
echo ""

# Count source files
if [ -d "net/minecraft/client" ]; then
    CLIENT_FILE_COUNT=$(find net/minecraft/client -name "*.java" | wc -l)
    echo -e "Client source files: ${GREEN}$CLIENT_FILE_COUNT${NC}"
else
    echo -e "Client source files: ${RED}NOT FOUND${NC}"
fi

if [ -d "net/minecraft/server" ]; then
    SERVER_FILE_COUNT=$(find net/minecraft/server -name "*.java" | wc -l)
    echo -e "Server source files: ${GREEN}$SERVER_FILE_COUNT${NC}"
else
    echo -e "Server source files: ${RED}NOT FOUND${NC}"
fi

TOTAL_FILE_COUNT=$(find net/minecraft -name "*.java" 2>/dev/null | wc -l || echo "0")
echo -e "Total Minecraft source files: ${GREEN}$TOTAL_FILE_COUNT${NC}"

echo ""

# Cleanup temp directory
echo -e "${BLUE}Step 9: Cleaning up temporary files...${NC}"
echo ""
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✓ Cleanup completed${NC}"

echo ""
echo "========================================================================"
echo -e "${GREEN}SUCCESS! Minecraft $MC_VERSION source code decompilation complete${NC}"
echo "========================================================================"
echo ""
echo "What's been added:"
echo "  - net/minecraft/client/    (Client-side code: GUI, rendering, etc.)"
echo "  - net/minecraft/server/    (Server-side code: game logic, etc.)"
echo "  - net/minecraft/...        (Shared code: entities, blocks, items, etc.)"
echo ""
echo "Next steps:"
echo "  1. Review the decompiled sources in net/minecraft/"
echo "  2. Check MOVETHIS/net/minecraft/ for the transfer copy"
echo "  3. Commit the changes to your repository"
echo "  4. Start developing your mod in src/main/java/"
echo ""
echo "IMPORTANT NOTES:"
echo "  • Decompiled sources are for REFERENCE only, not for compilation"
echo "  • Write your mod code in src/main/java/, not in net/minecraft/"
echo "  • If you get compilation errors, see DEPENDENCIES.md for solutions"
echo "  • Use Fabric APIs instead of Minecraft internals when possible"
echo "  • Do not redistribute the decompiled Minecraft code"
echo ""

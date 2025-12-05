#!/bin/bash

################################################################################
# Minecraft Version Lookup Test Script
################################################################################
# This script tests if Minecraft 1.21.10 can be found in Mojang's manifest
# Use this to diagnose issues with download-and-decompile-client.sh
################################################################################

set -e

MC_VERSION="1.21.10"
VERSION_MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest_v2.json"

echo "========================================================================"
echo "Minecraft Version Lookup Test"
echo "========================================================================"
echo ""
echo "Testing lookup for: $MC_VERSION"
echo ""

# Check for download tool
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -s"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -q -O -"
else
    echo "ERROR: Neither curl nor wget is installed"
    exit 1
fi

echo "Step 1: Downloading version manifest..."
MANIFEST=$($DOWNLOAD_CMD "$VERSION_MANIFEST_URL")

if [ -z "$MANIFEST" ]; then
    echo "ERROR: Failed to download manifest"
    exit 1
fi

echo "✓ Manifest downloaded"
echo ""

# Try Python parsing (best method)
if command -v python3 &> /dev/null; then
    echo "Step 2: Parsing with Python (recommended method)..."
    echo ""
    
    python3 << 'PYEOF'
import json, sys

MC_VERSION = "1.21.10"
manifest = json.loads(sys.stdin.read())

print("Recent Minecraft versions in manifest:")
print("-" * 60)
for i, version in enumerate(manifest.get('versions', [])[:15]):
    vid = version.get('id', 'unknown')
    vtype = version.get('type', 'unknown')
    marker = " ← MATCH!" if vid == MC_VERSION else ""
    print(f"{i+1:2}. {vid:20} ({vtype}){marker}")

print("-" * 60)
print()

# Try to find our version
found = False
for version in manifest.get('versions', []):
    if version.get('id') == MC_VERSION:
        found = True
        print(f"✓ FOUND: Minecraft {MC_VERSION}")
        print(f"  Type: {version.get('type')}")
        print(f"  URL: {version.get('url')}")
        print(f"  Release Time: {version.get('releaseTime', 'unknown')}")
        
        # Try to get client URL
        print()
        print("Fetching client download URL...")
        import urllib.request
        try:
            with urllib.request.urlopen(version.get('url')) as response:
                version_data = json.loads(response.read())
                client_url = version_data.get('downloads', {}).get('client', {}).get('url')
                if client_url:
                    print(f"✓ Client JAR URL: {client_url}")
                else:
                    print("✗ Could not find client URL in version data")
        except Exception as e:
            print(f"✗ Error fetching version data: {e}")
        break

if not found:
    print(f"✗ NOT FOUND: Minecraft {MC_VERSION}")
    print()
    print("Possible reasons:")
    print("  1. Version number typo (should be exactly '1.21.10')")
    print("  2. Version not yet released or removed")
    print("  3. Different version naming (e.g., '1.21.1' not '1.21.10')")
    print()
    print("Check available versions above and in gradle.properties")
    sys.exit(1)
PYEOF
    exit_code=$?
    echo ""
    
    if [ $exit_code -eq 0 ]; then
        echo "========================================================================"
        echo "✓ SUCCESS: Version lookup working correctly"
        echo "========================================================================"
        echo ""
        echo "The download-and-decompile-client.sh script should work."
        echo "If it still fails, there may be a different issue."
    else
        echo "========================================================================"
        echo "✗ FAILED: Version not found"
        echo "========================================================================"
        echo ""
        echo "Please check:"
        echo "  1. Is '1.21.10' the correct version number?"
        echo "  2. Check gradle.properties for the minecraft_version setting"
        echo "  3. Look at the version list above for available versions"
    fi
else
    echo "Python3 not found - using basic grep method..."
    echo ""
    echo "Recent versions found in manifest:"
    echo "$MANIFEST" | grep -o '"id":"[^"]*"' | head -15 | sed 's/"id":"\([^"]*\)"/  - \1/'
    echo ""
    
    FOUND=$(echo "$MANIFEST" | grep -o "\"id\":\"$MC_VERSION\"")
    if [ -n "$FOUND" ]; then
        echo "✓ Version $MC_VERSION found in manifest"
    else
        echo "✗ Version $MC_VERSION NOT found in manifest"
        echo ""
        echo "Please verify the version number and check available versions above"
    fi
fi

echo ""
echo "To fix version mismatch:"
echo "  1. Check gradle.properties and update minecraft_version"
echo "  2. Or manually specify version in the download script"
echo ""

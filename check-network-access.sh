#!/bin/bash

# Script to check network access to required domains for Minecraft modding

echo "========================================="
echo "Minecraft Modding Network Access Checker"
echo "========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check domain access
check_domain() {
    local domain=$1
    local description=$2
    
    echo -n "Checking $domain ... "
    
    if curl -s -I --max-time 5 "https://$domain/" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ ACCESSIBLE${NC}"
        return 0
    else
        echo -e "${RED}✗ BLOCKED${NC}"
        echo "   Purpose: $description"
        return 1
    fi
}

# Check all required domains
echo "Checking required domains:"
echo ""

failed=0

check_domain "maven.fabricmc.net" "Fabric Loom plugin, Fabric Loader, Fabric API" || failed=$((failed+1))
check_domain "launchermeta.mojang.com" "Minecraft version manifests" || failed=$((failed+1))
check_domain "piston-data.mojang.com" "Minecraft JAR downloads" || failed=$((failed+1))

echo ""
echo "Additional repositories:"
check_domain "repo.maven.apache.org" "Maven Central Repository" || failed=$((failed+1))
check_domain "plugins.gradle.org" "Gradle Plugin Portal" || failed=$((failed+1))

echo ""
echo "========================================="

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✓ All domains are accessible!${NC}"
    echo ""
    echo "You can now run:"
    echo "  ./gradlew build"
    echo "  ./gradlew genSources"
    echo "  ./gradlew extractMinecraftSources"
else
    echo -e "${RED}✗ $failed domain(s) are blocked${NC}"
    echo ""
    echo -e "${YELLOW}ACTION REQUIRED:${NC}"
    echo "Please request access to the blocked domains from your"
    echo "network administrator or system security team."
    echo ""
    echo "These domains are:"
    echo "  1. Official Mojang/Microsoft domains"
    echo "  2. Official Fabric mod loader domains"
    echo "  3. Required for legitimate Minecraft mod development"
    echo ""
    echo "After access is granted, run this script again to verify."
fi

echo "========================================="
echo ""

exit $failed

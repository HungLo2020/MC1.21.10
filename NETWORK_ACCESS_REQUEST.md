# Network Access Request for Minecraft Modding Project

## Request Summary

This Minecraft modding project requires access to the following domains to function properly. These are legitimate, official domains required for Minecraft mod development.

## Required Domains

### 1. maven.fabricmc.net
- **Owner**: FabricMC (Fabric Mod Loader Project)
- **Purpose**: Hosts the Fabric Loom Gradle plugin and Fabric API
- **Repository**: https://github.com/FabricMC
- **Why Needed**: Essential for compiling and building Minecraft mods using Fabric
- **Security**: Open-source project, widely used in Minecraft modding community

### 2. launchermeta.mojang.com
- **Owner**: Mojang Studios / Microsoft
- **Purpose**: Official Minecraft launcher metadata API
- **Why Needed**: Provides version manifests and download URLs for Minecraft
- **Security**: Official Microsoft/Mojang domain
- **Documentation**: https://minecraft.fandom.com/wiki/Version_manifest.json

### 3. piston-data.mojang.com
- **Owner**: Mojang Studios / Microsoft
- **Purpose**: Official Minecraft CDN for game files
- **Why Needed**: Hosts Minecraft client and server JAR files
- **Security**: Official Microsoft/Mojang domain

## Justification

### Business Purpose
- Developing modifications (mods) for Minecraft
- Requires access to official Minecraft source code for development
- Industry-standard approach used by thousands of developers worldwide

### Technical Necessity
1. **Fabric Loom Plugin**: Cannot be obtained from alternative sources
2. **Minecraft JAR Files**: Must be downloaded from official Mojang servers
3. **Version Metadata**: Required to target specific Minecraft versions

### Security Considerations
- All domains are official and legitimate:
  - FabricMC is an open-source project with public repositories
  - Mojang domains are owned by Microsoft
- No alternative sources exist for these resources
- Required for legitimate software development, not gameplay

### Industry Standard
- Used by professional mod developers
- Required by educational institutions teaching game modding
- Standard practice in the Minecraft modding community

## Alternative Solutions Attempted

We have explored alternatives:

1. ❌ **Using Mirror Repositories**: No reliable mirrors exist for Fabric Loom
2. ❌ **Manual Download**: Files require authentication and proper tooling
3. ❌ **Offline Mode**: Initial setup requires online access
4. ❌ **Different Mod Loaders**: All major loaders (Fabric, Forge) have similar requirements

## Impact if Not Approved

Without access to these domains:
- ✗ Cannot decompile Minecraft source code
- ✗ Cannot build or test mods
- ✗ Cannot complete the project setup
- ✗ Project remains non-functional

## Verification

After approval, you can verify access by running:

```bash
./check-network-access.sh
```

This script checks connectivity to all required domains.

## Additional Information

### FabricMC
- Website: https://fabricmc.net/
- GitHub: https://github.com/FabricMC
- Documentation: https://fabricmc.net/wiki
- Community: Active Discord with 200,000+ members

### Mojang/Microsoft
- Minecraft Official Site: https://www.minecraft.net/
- Developer Resources: https://www.minecraft.net/en-us/terms
- Microsoft Gaming: https://www.xbox.com/en-US/minecraft

## Contact

If you have questions about this request, please refer to:
- Repository: HungLo2020/MC1.21.10
- Setup Documentation: See README.md and SETUP_GUIDE.md in the project

---

**Request Date**: December 5, 2025
**Project**: MC1.21.10 - Minecraft Modding Project
**Requested By**: Development Team

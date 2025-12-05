# Quick Start Guide

## Current Status

✅ **Minecraft 1.21.10 Fabric modding project has been set up!**

The repository now contains:
- Complete Gradle build configuration
- Fabric Loom plugin setup
- Example mod source code
- All necessary configuration files

## ⚠️ Network Access Required

To complete the setup and extract Minecraft source code, you need access to:
- `maven.fabricmc.net`
- `launchermeta.mojang.com`
- `piston-data.mojang.com`

## Next Steps

### 1. Check Network Access

```bash
./check-network-access.sh
```

### 2. If Access is Granted

Run these commands:

```bash
# Download and decompile Minecraft
./gradlew genSources

# Extract source code to project root
./gradlew extractMinecraftSources
```

### 3. If Access is Still Blocked

See `NETWORK_ACCESS_REQUEST.md` for a template to request access from your IT department.

## What You Can Do Now

Even without network access, you can:

1. **Review the Project Structure**
   - Explore `src/main/` and `src/client/` directories
   - Look at the example mod code
   - Review `build.gradle` configuration

2. **Read Documentation**
   - `README.md` - Overview and instructions
   - `SETUP_GUIDE.md` - Detailed setup steps
   - `NETWORK_ACCESS_REQUEST.md` - IT access request template

3. **Prepare for Development**
   - Study Fabric modding documentation: https://fabricmc.net/wiki
   - Review the example mod structure
   - Plan your mod features

## Quick Command Reference

| Command | Purpose |
|---------|---------|
| `./check-network-access.sh` | Verify domain accessibility |
| `./gradlew tasks` | List all available Gradle tasks |
| `./gradlew build` | Build your mod (requires network) |
| `./gradlew runClient` | Run Minecraft with your mod |
| `./gradlew genSources` | Decompile Minecraft sources |
| `./gradlew extractMinecraftSources` | Extract sources to root |

## Getting Help

- Full documentation: `README.md`
- Detailed guide: `SETUP_GUIDE.md`
- Network issues: `NETWORK_ACCESS_REQUEST.md`
- Fabric Discord: https://discord.gg/v6v4pMv

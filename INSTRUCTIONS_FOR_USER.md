# Instructions: Adding Client Source Code

## Current Situation

Your repository has been set up with scripts and documentation to add the missing Minecraft client source code. However, **I cannot run the download and decompilation myself** due to network access restrictions.

## What's Missing?

The repository currently has:
- ✅ Server-side Minecraft code (~200-300 files in `net/minecraft/server/`)
- ✅ Shared/common code (~2,500+ files)
- ❌ **Client-side code (MISSING)** - Should be ~1,500-2,000 files in `net/minecraft/client/`

### Why Client Code Matters

Without client sources, you're missing:
- `Minecraft.java` - Main client class
- All GUI code (screens, widgets, menus)
- Rendering engine (blocks, entities, particles, shaders)
- Input handling (keyboard, mouse, controller)
- Resource loading (textures, models, sounds)
- Multiplayer client logic
- Client-side entity rendering
- And much more...

## What I've Created for You

I've set up everything you need to fix this:

### 1. Automated Script: `download-and-decompile-client.sh`
**This is the easiest option - run this one command:**
```bash
./download-and-decompile-client.sh
```

This script will:
1. Download Minecraft 1.21.10 client JAR from Mojang
2. Use Fabric Loom to decompile with official mappings
3. Extract both client and server sources
4. Update the MOVETHIS folder
5. Verify everything worked

**Time:** 5-15 minutes  
**Requirements:** Network access, Java 21+, curl/wget

### 2. Alternative: `download-client-jar.sh`
If you want more control:
```bash
./download-client-jar.sh
./gradlew genSources
./gradlew extractMinecraftSources
```

### 3. Documentation
- **[ADD_CLIENT_SOURCES.md](ADD_CLIENT_SOURCES.md)** - Complete guide
- **[QUICK_FIX.md](QUICK_FIX.md)** - Quick reference
- **Updated README.md** - Now mentions missing client sources
- **Updated START_HERE.md** - Prominent warning about issue

### 4. Enhanced Gradle Task
The `extractMinecraftSources` task in `build.gradle` has been improved to:
- Better logging and progress reporting
- Extract both client and server sources
- Automatically update MOVETHIS folder
- Verify extraction with file counts

## What You Need to Do

### Step 1: Ensure Prerequisites

Make sure you have:
- ✅ Java 21+ installed (`java -version`)
- ✅ curl or wget installed (`curl --version` or `wget --version`)
- ✅ Network access to:
  - launchermeta.mojang.com
  - piston-data.mojang.com
  - maven.fabricmc.net

If you don't have network access, see the "No Network Access?" section below.

### Step 2: Run the Script

Pull the latest changes and run the script:
```bash
# Pull the latest changes (includes the new scripts)
git pull origin copilot/add-client-source-code

# Make sure the script is executable (should already be)
chmod +x download-and-decompile-client.sh

# Run the decompilation script
./download-and-decompile-client.sh
```

### Step 3: Verify It Worked

After the script completes, verify:
```bash
# Check if client directory exists
ls -la net/minecraft/client/

# Count client files (should be ~1,500-2,000)
find net/minecraft/client -name "*.java" | wc -l

# Check total files (should be ~4,500+)
find net/minecraft -name "*.java" | wc -l
```

### Step 4: Commit the Changes

Once verified:
```bash
# Check what was added
git status

# Add the new sources
git add net/ MOVETHIS/

# Commit
git commit -m "Add Minecraft 1.21.10 client source code"

# Push to your repository
git push
```

## Troubleshooting

### Network Access Blocked?

If you get errors about blocked domains:
1. Read `NETWORK_ACCESS_REQUEST.md`
2. Request IT to whitelist the required domains
3. Try again once access is granted

**OR** use the Manual Minecraft Launcher method:
1. Install Minecraft Launcher
2. Launch Minecraft 1.21.10 once
3. Find the JAR in `.minecraft/versions/1.21.10/`
4. Copy to project root as `minecraft-client.jar`
5. Run: `./gradlew genSources`
6. Run: `./gradlew extractMinecraftSources`

### Fabric Loom Plugin Not Found?

If you get "Plugin fabric-loom was not found":
- Ensure `maven.fabricmc.net` is accessible
- This domain hosts the Fabric Loom Gradle plugin
- Without it, the decompilation cannot proceed

### Java Version Issues?

If you get Java version errors:
- Install Java 21 from https://adoptium.net/
- Verify: `java -version`
- Update your PATH if needed

### Script Fails Midway?

Check the error message and:
1. Verify network access with `./check-network-access.sh`
2. Try cleaning Gradle cache: `./gradlew clean`
3. Try removing Loom cache: `rm -rf .gradle/loom-cache`
4. Run the script again

## Alternative Approaches

### If Scripts Don't Work

You can manually:
1. Download client JAR from a trusted source (MCVersions.net, etc.)
2. Place it in project root as `minecraft-client-1.21.10.jar`
3. Modify `decompile-minecraft.gradle` to use your JAR
4. Run the decompilation

### If You Want Minimal Download

The scripts download and extract everything. If you have limited bandwidth:
1. Use `download-client-jar.sh` to only get the JAR (~25MB)
2. Decompilation happens locally
3. No additional downloads needed (if Fabric Loom is cached)

## Expected Results

After successful completion, your repository will have:

```
MC1.21.10/
├── net/
│   └── minecraft/
│       ├── client/          ← NEW! ~1,500-2,000 files
│       │   ├── Minecraft.java
│       │   ├── gui/
│       │   │   ├── screens/
│       │   │   ├── components/
│       │   │   └── ...
│       │   ├── renderer/
│       │   │   ├── entity/
│       │   │   ├── block/
│       │   │   └── ...
│       │   ├── multiplayer/
│       │   ├── resources/
│       │   └── ...
│       ├── server/          ← Already present
│       ├── world/
│       ├── entity/
│       └── ...
│
└── MOVETHIS/
    └── net/
        └── minecraft/
            ├── client/      ← NEW! Updated
            └── ...
```

Total: ~4,500+ Java source files

## Summary

**What I Did:**
- Created automated decompilation script
- Created documentation and guides
- Enhanced Gradle tasks
- Updated README files

**What You Need to Do:**
1. Run `./download-and-decompile-client.sh`
2. Wait 5-15 minutes
3. Verify client sources exist
4. Commit and push the changes

**If you have any issues:**
- Check the documentation files
- Verify network access
- Try alternative methods
- The scripts include detailed error messages to help diagnose problems

---

## Quick Command Summary

```bash
# Pull latest changes
git pull origin copilot/add-client-source-code

# Run decompilation (easiest method)
./download-and-decompile-client.sh

# Or step-by-step
./download-client-jar.sh
./gradlew genSources
./gradlew extractMinecraftSources

# Verify
ls -la net/minecraft/client/
find net/minecraft/client -name "*.java" | wc -l

# Commit
git add net/ MOVETHIS/
git commit -m "Add Minecraft 1.21.10 client source code"
git push
```

---

**Questions?** Read the documentation files or check the script comments for more details.

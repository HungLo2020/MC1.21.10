# Adding Client Source Code to Repository

## Current Issue

This repository currently contains **only server-side Minecraft source code**. The client-side code (GUI, rendering, client-only logic) is missing and needs to be added.

### What's Missing?

- ❌ `net/minecraft/client/` - Client-side code
  - Minecraft.java (main client class)
  - GUI components (screens, widgets, menus)
  - Rendering engine (blocks, entities, particles)
  - Client input handling (keyboard, mouse, controller)
  - Resource loading (textures, models, sounds)
  - And much more...

### What's Currently Present?

- ✅ `net/minecraft/server/` - Server-side code
- ✅ `net/minecraft/world/` - World generation and management
- ✅ `net/minecraft/entity/` - Entity classes
- ✅ `net/minecraft/block/` - Block classes
- ✅ `net/minecraft/item/` - Item classes
- ✅ Shared/common code

## Solution

A script has been created to download and decompile the Minecraft 1.21.10 client JAR with both client and server sources.

### Prerequisites

Before running the script, ensure you have:

1. **Network Access** to the following domains:
   - `launchermeta.mojang.com` - Version manifests
   - `piston-data.mojang.com` - Minecraft JARs
   - `maven.fabricmc.net` - Fabric Loom and dependencies

2. **Java 21+** installed and available in PATH
   ```bash
   java -version
   ```

3. **curl** or **wget** installed
   ```bash
   curl --version
   # or
   wget --version
   ```

### How to Run

1. **Make sure you're in the repository root directory:**
   ```bash
   cd /path/to/MC1.21.10
   ```

2. **Run the decompilation script:**
   ```bash
   ./download-and-decompile-client.sh
   ```

3. **Wait for completion** (5-15 minutes depending on your system)
   - The script will download the Minecraft client JAR
   - Run Fabric Loom's genSources task
   - Extract the decompiled sources
   - Update the MOVETHIS folder

### What the Script Does

```
Step 1: Checks prerequisites (Java, curl/wget)
Step 2: Fetches Minecraft version manifest from Mojang
Step 3: Downloads version-specific metadata
Step 4: Downloads Minecraft 1.21.10 client JAR (~25MB)
Step 5: Runs Fabric Loom genSources (decompiles code)
Step 6: Extracts decompiled sources to project root
Step 7: Updates MOVETHIS folder with client sources
Step 8: Verifies source file counts
Step 9: Cleans up temporary files
```

### Expected Results

After successful completion, you should have:

```
MC1.21.10/
├── net/
│   └── minecraft/
│       ├── client/          ← NEW! Client code (~1500+ files)
│       │   ├── Minecraft.java
│       │   ├── gui/
│       │   ├── renderer/
│       │   ├── resources/
│       │   ├── multiplayer/
│       │   └── ...
│       ├── server/          ← Already present
│       ├── world/
│       ├── entity/
│       └── ...
│
└── MOVETHIS/
    └── net/
        └── minecraft/
            ├── client/      ← NEW! Client code copy
            └── ...
```

### File Counts

A complete Minecraft 1.21.10 decompilation typically includes:

- **Client files**: ~1,500-2,000 .java files
- **Server files**: ~200-300 .java files  
- **Shared files**: ~2,500-3,000 .java files
- **Total**: ~4,500+ .java files

Currently, the repository has approximately 4,500 files but is missing the client-specific code.

## Troubleshooting

### Network Access Denied

If you get network errors:

```
ERROR: Failed to download version manifest
```

**Solution**: You need access to the Mojang domains. Contact your network administrator or use the `NETWORK_ACCESS_REQUEST.md` file to request access.

### Fabric Loom Plugin Not Found

If you get:

```
Plugin [id: 'fabric-loom'] was not found
```

**Solution**: Ensure `maven.fabricmc.net` is accessible. This domain hosts the Fabric Loom plugin.

### Java Version Too Old

If you get Java version warnings:

```
WARNING: Java 21+ is recommended
```

**Solution**: Install Java 21 or higher. Minecraft 1.21.10 requires Java 21.

### Sources Already Exist

If client sources are already present, the script will update them. To force a clean decompilation:

```bash
# Clean existing Gradle cache
./gradlew clean
rm -rf .gradle/loom-cache

# Re-run the script
./download-and-decompile-client.sh
```

## Alternative Methods

If the script doesn't work for you, here are alternative approaches:

### Method 1: Manual Fabric Loom

If you already have the Minecraft JAR:

```bash
# Generate sources
./gradlew genSources

# Extract to project root  
./gradlew extractMinecraftSources
```

### Method 2: Use Minecraft Launcher

1. Install and run Minecraft Launcher
2. Launch Minecraft 1.21.10 at least once
3. Find the client JAR at:
   - Windows: `%APPDATA%\.minecraft\versions\1.21.10\1.21.10.jar`
   - Mac: `~/Library/Application Support/minecraft/versions/1.21.10/1.21.10.jar`
   - Linux: `~/.minecraft/versions/1.21.10/1.21.10.jar`
4. Copy it to this project root as `minecraft-client.jar`
5. Run: `./gradlew -b decompile-minecraft.gradle decompileMinecraftJar`

### Method 3: Community Archives

Download from trusted community sites (use at your own risk):

- MCVersions.net
- MinecraftVersions.org

Then follow Method 2 steps 4-5.

## After Adding Client Sources

Once the client sources are added:

1. **Verify the sources:**
   ```bash
   # Check client directory exists
   ls -la net/minecraft/client/
   
   # Count client files
   find net/minecraft/client -name "*.java" | wc -l
   ```

2. **Test the build:**
   ```bash
   ./gradlew build
   ```

3. **Test running the client:**
   ```bash
   ./gradlew runClient
   ```

4. **Commit the changes:**
   ```bash
   git add net/ MOVETHIS/
   git commit -m "Add Minecraft 1.21.10 client source code"
   git push
   ```

## Important Notes

### Legal Considerations

- ✅ **Allowed**: Decompiling Minecraft for personal mod development
- ✅ **Allowed**: Using decompiled code as reference
- ❌ **NOT Allowed**: Redistributing decompiled Minecraft source code
- ❌ **NOT Allowed**: Using decompiled code in commercial products

### Repository Size

Adding client sources will increase the repository size by approximately:

- **Compressed (in Git)**: ~5-10 MB
- **Uncompressed**: ~30-40 MB

If you want to keep the repository small, consider adding to `.gitignore`:

```
# Exclude decompiled Minecraft sources from Git
net/
com/mojang/
MOVETHIS/net/
MOVETHIS/com/
```

But note: This means collaborators will need to run the decompilation themselves.

## Need Help?

1. Check the network access: `./check-network-access.sh`
2. Review the documentation: `README.md`, `SETUP_GUIDE.md`
3. Visit Fabric documentation: https://fabricmc.net/wiki
4. Join Fabric Discord: https://discord.gg/v6v4pMv

---

**Script Location**: `./download-and-decompile-client.sh`  
**Created**: December 2025  
**Minecraft Version**: 1.21.10  
**Fabric Loom**: 1.11.7  

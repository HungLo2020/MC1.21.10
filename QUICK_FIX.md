# Quick Fix: Add Client Source Code

## Problem
Repository only has **server** code, missing **client** code (GUI, rendering, etc.)

## Solution Options

### Option 1: Automatic (Recommended)
Run the automated script:
```bash
./download-and-decompile-client.sh
```

**Requirements:**
- Network access to mojang.com and maven.fabricmc.net
- Java 21+
- curl or wget

**Time:** 5-15 minutes

---

### Option 2: Download JAR Only
If you want more control:
```bash
# Step 1: Download client JAR
./download-client-jar.sh

# Step 2: Generate sources with Fabric Loom
./gradlew genSources

# Step 3: Extract to repository
./gradlew extractMinecraftSources
```

---

### Option 3: Manual with Minecraft Launcher
If you already have Minecraft installed:

1. Launch Minecraft 1.21.10 once
2. Find the JAR:
   - **Windows**: `%APPDATA%\.minecraft\versions\1.21.10\1.21.10.jar`
   - **Mac**: `~/Library/Application Support/minecraft/versions/1.21.10/1.21.10.jar`
   - **Linux**: `~/.minecraft/versions/1.21.10/1.21.10.jar`
3. Copy to project root as `minecraft-client.jar`
4. Run: `./gradlew genSources`
5. Run: `./gradlew extractMinecraftSources`

---

## After Adding Client Sources

Verify it worked:
```bash
# Check if client directory exists
ls -la net/minecraft/client/

# Count files
find net/minecraft/client -name "*.java" | wc -l
```

Expected: ~1,500-2,000 client Java files

---

## Troubleshooting

### Network Blocked?
Read `NETWORK_ACCESS_REQUEST.md` to request IT access

### No Java?
Install Java 21: https://adoptium.net/

### Still Failing?
See full documentation: `ADD_CLIENT_SOURCES.md`

---

## What You Get

After successful completion:

```
net/minecraft/
├── client/          ← NEW! Client code
│   ├── Minecraft.java
│   ├── gui/         ← GUI screens
│   ├── renderer/    ← Rendering engine
│   ├── multiplayer/ ← Multiplayer client
│   └── ...
├── server/          ← Already present
└── ...              ← Shared code
```

Total: ~4,500+ Java source files

---

**Need detailed help?** Read [ADD_CLIENT_SOURCES.md](ADD_CLIENT_SOURCES.md)

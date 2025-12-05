# Detailed Setup Guide for Minecraft 1.21.10 Modding Project

## What Has Been Set Up

This repository now contains:

1. **Complete Fabric Modding Project Structure**
   - Gradle build system with wrapper
   - Fabric Loom plugin configuration
   - Example mod source code
   - Proper directory structure for Fabric mods

2. **Configuration Files**
   - `build.gradle` - Build configuration with Fabric Loom 1.9.2
   - `gradle.properties` - Version configurations for MC 1.21.10
   - `settings.gradle` - Gradle plugin repositories
   - `.gitignore` - Excludes build artifacts and caches

3. **Source Code Structure**
   - `src/main/` - Server and common code
   - `src/client/` - Client-only code
   - Example mod classes and mixins
   - Fabric mod metadata (`fabric.mod.json`)

4. **Custom Decompilation Script**
   - `decompile-minecraft.gradle` - Alternative decompilation approach

## The Network Access Issue

The automatic setup cannot complete because these domains are blocked:

### Required Domains

| Domain | Purpose |
|--------|---------|
| `maven.fabricmc.net` | Fabric Loom plugin, Fabric Loader, Fabric API |
| `launchermeta.mojang.com` | Minecraft version manifests and metadata |
| `piston-data.mojang.com` | Minecraft client/server JAR downloads |

### Why These Are Needed

1. **maven.fabricmc.net**: Hosts the Fabric Loom Gradle plugin, which is the core tool for:
   - Decompiling Minecraft
   - Applying mappings (converting obfuscated names to readable names)
   - Setting up the development environment
   - Building and packaging mods

2. **launchermeta.mojang.com**: Official Mojang API for:
   - Getting version manifests
   - Finding download URLs for specific Minecraft versions
   - Obtaining checksums and metadata

3. **piston-data.mojang.com**: Official Mojang CDN for:
   - Downloading Minecraft JAR files
   - Downloading required libraries and assets

## How to Complete the Setup

### Step 1: Request Domain Access

Contact your system administrator or network team to whitelist these domains. Explain that they are:
- Official Mojang/Microsoft domains (launchermeta, piston-data)
- Official Fabric mod loader domains (maven.fabricmc.net)
- Required for legitimate Minecraft mod development

### Step 2: Verify Access

Once whitelisted, test access:

```bash
curl -I https://maven.fabricmc.net/
curl -I https://launchermeta.mojang.com/
curl -I https://piston-data.mojang.com/
```

All should return `200 OK` responses.

### Step 3: Build the Project

```bash
# This will download all dependencies
./gradlew build
```

Expected output:
- Downloads Fabric Loom plugin
- Downloads Minecraft 1.21.10
- Downloads Fabric Loader and API
- Compiles the example mod

### Step 4: Generate Decompiled Sources

```bash
# Generate decompiled Minecraft sources
./gradlew genSources
```

This task:
1. Downloads Minecraft 1.21.10 client JAR
2. Applies Mojang's official mappings
3. Decompiles the JAR using VineFlower
4. Creates a sources JAR in the Loom cache

Expected location of sources:
```
.gradle/loom-cache/minecraftMaven/net/minecraft/.../minecraft-...-sources.jar
```

### Step 5: Extract Sources to Project Root

```bash
# Extract decompiled sources to project root
./gradlew extractMinecraftSources
```

This custom task:
1. Locates the generated sources JAR
2. Extracts all `.java` files to the project root directory
3. Preserves the package structure (e.g., `net/minecraft/...`)

After this step, you'll have the full Minecraft source code in your repository root.

## Alternative: Manual Process

If domain access cannot be granted, you can manually set up the environment:

### Manual Method 1: Use Another Computer

1. On a computer with internet access:
   ```bash
   git clone <this-repository>
   cd MC1.21.10
   ./gradlew build
   ./gradlew genSources
   ```

2. Copy the `.gradle` directory to this environment
3. Run `./gradlew extractMinecraftSources` here

### Manual Method 2: Direct JAR Decompilation

1. Obtain `minecraft-client-1.21.10.jar` manually
2. Place it in the project root as `minecraft-client.jar`
3. Run: `./gradlew -b decompile-minecraft.gradle decompileMinecraftJar`

Note: This method won't apply mappings, so code will use obfuscated names.

### Manual Method 3: Use MCP Reborn or RetroMCP

Alternative decompiler tools:
- [MCP Reborn](https://github.com/Hexeption/MCP-Reborn)
- [MCPConfig](https://github.com/MinecraftForge/MCPConfig)

These tools can decompile Minecraft independently but require different setup.

## Understanding the Project Structure After Decompilation

Once sources are extracted, your project will look like:

```
MC1.21.10/
├── net/
│   └── minecraft/
│       ├── client/          # Client-side code
│       ├── server/          # Server-side code
│       ├── world/           # World generation, blocks, etc.
│       ├── entity/          # Entity classes
│       ├── item/            # Item classes
│       └── ...              # And much more
├── com/
│   └── mojang/              # Mojang utilities
├── src/
│   ├── main/                # Your mod code
│   └── client/              # Your client code
├── build.gradle
└── ...
```

## Working with Decompiled Sources

### DO:
- ✅ Browse and read the code for learning
- ✅ Reference vanilla implementations
- ✅ Understand game mechanics
- ✅ Copy small code snippets for your mods (with attribution)

### DON'T:
- ❌ Redistribute decompiled Minecraft source code
- ❌ Modify Minecraft's code directly (use mixins instead)
- ❌ Claim ownership of Minecraft code
- ❌ Violate Mojang's EULA or terms of service

## Next Steps After Setup

1. **Explore the Code**: Browse `net/minecraft/` to understand game systems
2. **Modify Example Mod**: Edit files in `src/main/java/com/example/`
3. **Test Your Mod**: Run `./gradlew runClient` to launch Minecraft with your mod
4. **Use Mixins**: Study `src/main/java/com/example/mixin/` for code injection examples
5. **Read Fabric Docs**: Visit https://fabricmc.net/wiki for detailed guides

## Troubleshooting

### "Could not resolve fabric-loom"
- Cause: maven.fabricmc.net not accessible
- Solution: Request domain whitelist

### "Could not download Minecraft"
- Cause: Mojang domains not accessible
- Solution: Request domain whitelist or use manual method

### "genSources not found"
- Cause: Fabric Loom plugin not loaded
- Solution: Fix repository access first, then re-sync

### Build succeeds but no sources generated
- Try: `./gradlew clean genSources --refresh-dependencies`

### Out of memory during decompilation
- Edit `gradle.properties`: Increase `-Xmx2G` to `-Xmx4G` or higher

## Getting Help

If you encounter issues:

1. Check this guide first
2. Review the main README.md
3. Check Fabric documentation
4. Ask on Fabric Discord: https://discord.gg/v6v4pMv
5. Search GitHub issues on Fabric Loom repository

## Summary

✅ Project structure is ready
✅ Fabric configuration is correct
✅ Example mod is included
❌ Network access is blocked (requires whitelist)
⏳ Waiting for domain access to complete decompilation

Once network access is resolved, the full setup can be completed with just 2 commands:
```bash
./gradlew genSources
./gradlew extractMinecraftSources
```

# Quick Fix: Compilation Errors with Decompiled Sources

## The Problem

You're seeing errors like:
- `cannot find symbol: class GameProfile`
- `package com.jcraft.jorbis does not exist`
- `cannot find symbol: method getName()`
- `FabricProvidedTagBuilder needs type parameters`
- Type inference errors in generics

## The Solution

**Don't compile the decompiled sources!** They are for reference only.

### Understanding the Setup

```
your-project/
├── src/main/java/          ← YOUR mod code (this compiles)
│   └── com/example/
│       └── YourMod.java
│
└── net/minecraft/          ← Decompiled sources (reference ONLY)
    ├── client/             ← Browse, don't compile
    └── server/             ← Browse, don't compile
```

## Step-by-Step Fix

### 1. Keep Decompiled Sources Separate

The `net/minecraft/` directory is **not** part of your mod's source code. It's there for you to read and understand Minecraft's internals.

**Verify your source sets:**
```groovy
// In build.gradle - make sure you only have:
sourceSets {
    main {
        java {
            srcDir 'src/main/java'  // Only compile your code
        }
    }
}
```

### 2. Write Your Mod in src/main/java/

```java
// src/main/java/com/yourmod/YourMod.java
package com.yourmod;

import net.fabricmc.api.ModInitializer;

public class YourMod implements ModInitializer {
    @Override
    public void onInitialize() {
        // Your mod code here
    }
}
```

### 3. If You Need Minecraft Dependencies

Only add dependencies if YOUR mod code (in `src/main/java/`) needs them:

```groovy
// In build.gradle
dependencies {
    // Core dependencies (already present)
    minecraft "com.mojang:minecraft:${project.minecraft_version}"
    modImplementation "net.fabricmc.fabric-api:fabric-api:${project.fabric_version}"
    
    // Add ONLY if you use these in YOUR code:
    // implementation 'com.mojang:authlib:6.0.54'         // For GameProfile
    // implementation 'com.github.stephengold:j-ogg-all:1.0.4'  // For audio
}
```

### 4. Use Fabric APIs Instead

Instead of using Minecraft internals, use Fabric APIs:

```java
// ❌ DON'T: Use Minecraft internals directly
import net.minecraft.server.MinecraftServer;
MinecraftServer server = getMinecraftServer(); // Complex, version-dependent

// ✅ DO: Use Fabric API
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerLifecycleEvents;
ServerLifecycleEvents.SERVER_STARTED.register(server -> {
    // Your code here - much cleaner!
});
```

### 5. Use Mixins for Modifications

To modify Minecraft behavior, use mixins instead of editing decompiled code:

```java
// src/main/java/com/yourmod/mixin/ExampleMixin.java
@Mixin(MinecraftServer.class)
public class ExampleMixin {
    @Inject(method = "tick", at = @At("HEAD"))
    private void onTick(CallbackInfo ci) {
        // Your modification here
    }
}
```

## Common Mistakes

### ❌ Mistake 1: Trying to Compile Decompiled Code
```groovy
// DON'T add decompiled sources to your source set
sourceSets {
    main {
        java {
            srcDir 'net/minecraft'  // ❌ NO!
        }
    }
}
```

### ❌ Mistake 2: Editing Decompiled Files
Don't edit files in `net/minecraft/`. Create mixins instead.

### ❌ Mistake 3: Including Decompiled Code in JAR
Never package `net/minecraft/` in your mod JAR. It's already in Minecraft!

## Recommended Workflow

1. **Reference** the decompiled code to understand how things work
2. **Write** your mod code in `src/main/java/`
3. **Use** Fabric APIs when available
4. **Create** mixins when you need to modify Minecraft behavior
5. **Test** with `./gradlew runClient`

## Build Commands

```bash
# Clean build (recommended when troubleshooting)
./gradlew clean build

# Run client (test your mod)
./gradlew runClient

# Run server (test server-side)
./gradlew runServer
```

## Still Getting Errors?

### Check Your IDE Configuration

**IntelliJ IDEA:**
1. File → Project Structure → Modules
2. Verify only `src/main/java` and `src/client/java` are marked as source folders
3. `net/minecraft/` should NOT be marked as a source folder

**VS Code:**
1. Check `.vscode/settings.json`
2. Ensure Java source paths only include `src/`

### Verify Gradle Configuration

```bash
# Check what's being compiled
./gradlew compileJava --info | grep "source files"
```

Should only show files from `src/main/java/`, not `net/minecraft/`.

## Need More Help?

- **Full dependency guide:** [DEPENDENCIES.md](DEPENDENCIES.md)
- **Fabric documentation:** https://fabricmc.net/wiki/
- **Fabric Discord:** https://discord.gg/v6v4pMv

## Summary

✅ **DO:**
- Browse decompiled sources for reference
- Write your mod in `src/main/java/`
- Use Fabric APIs
- Use mixins for modifications

❌ **DON'T:**
- Try to compile `net/minecraft/`
- Edit decompiled files
- Include decompiled code in your JAR
- Use Minecraft internals directly when Fabric APIs exist

The decompiled sources are a **learning tool**, not part of your mod's compilation.

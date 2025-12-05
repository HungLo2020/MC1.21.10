# Minecraft Dependencies for Decompiled Sources

## Issue

When using the decompiled Minecraft source code in your project, you may encounter compilation errors due to missing dependencies. The decompiled sources reference libraries that Minecraft uses at runtime but aren't automatically included in your build.

## Common Missing Dependencies

### 1. Authlib (Mojang Authentication Library)

**Error symptoms:**
- `cannot find symbol: class GameProfile`
- `cannot find symbol: method getName()`
- `cannot find symbol: method getId()`

**Note:** The decompiled code may use `gameProfile.name()` and `gameProfile.id()`, but modern authlib uses `getName()` and `getId()`.

**Solution:**
```groovy
dependencies {
    // Authlib is provided by Minecraft dependency
    // But for direct usage, you can explicitly include it
    implementation 'com.mojang:authlib:6.0.54'
}
```

### 2. JOrbis (Ogg Vorbis Audio Decoder)

**Error symptoms:**
- `package com.jcraft.jorbis does not exist`
- Errors in audio/sound related classes

**Solution:**
```groovy
dependencies {
    implementation 'com.github.stephengold:j-ogg-all:1.0.4'
    // OR the original:
    // implementation 'org.jcraft:jorbis:0.0.17'
}
```

### 3. LWJGL (Lightweight Java Game Library)

**Error symptoms:**
- `package org.lwjgl does not exist`
- OpenGL/graphics related errors

**Note:** LWJGL is usually provided by Minecraft, but version mismatches can occur.

**Solution:**
```groovy
dependencies {
    // LWJGL 3.x for Minecraft 1.21+
    implementation platform('org.lwjgl:lwjgl-bom:3.3.3')
    implementation 'org.lwjgl:lwjgl'
    implementation 'org.lwjgl:lwjgl-glfw'
    implementation 'org.lwjgl:lwjgl-opengl'
    implementation 'org.lwjgl:lwjgl-stb'
}
```

### 4. Brigadier (Command System)

**Error symptoms:**
- `package com.mojang.brigadier does not exist`

**Solution:**
```groovy
dependencies {
    implementation 'com.mojang:brigadier:1.3.10'
}
```

### 5. DataFixerUpper (Data Version Management)

**Error symptoms:**
- `package com.mojang.datafixers does not exist`
- `package com.mojang.serialization does not exist`

**Solution:**
```groovy
dependencies {
    implementation 'com.mojang:datafixerupper:8.0.16'
}
```

## Complete Dependencies Configuration

Add these to your `build.gradle`:

```groovy
repositories {
    mavenCentral()
    maven { url 'https://libraries.minecraft.net' }
    maven { url 'https://maven.fabricmc.net' }
}

dependencies {
    // Minecraft and Fabric (already in your build.gradle)
    minecraft "com.mojang:minecraft:${project.minecraft_version}"
    mappings loom.officialMojangMappings()
    modImplementation "net.fabricmc:fabric-loader:${project.loader_version}"
    modImplementation "net.fabricmc.fabric-api:fabric-api:${project.fabric_version}"

    // Additional runtime dependencies for decompiled sources
    // (Add only what you need based on compilation errors)
    
    // Authlib - for authentication and GameProfile
    implementation 'com.mojang:authlib:6.0.54'
    
    // JOrbis - for Ogg Vorbis audio
    implementation 'com.github.stephengold:j-ogg-all:1.0.4'
    
    // Brigadier - for command system
    implementation 'com.mojang:brigadier:1.3.10'
    
    // DataFixerUpper - for data versioning
    implementation 'com.mojang:datafixerupper:8.0.16'
    
    // Logging (if needed)
    implementation 'org.apache.logging.log4j:log4j-api:2.24.1'
    implementation 'org.apache.logging.log4j:log4j-core:2.24.1'
}
```

## Important Notes

### 1. The Decompiled Sources Are For Reference Only

The decompiled Minecraft source code is intended as a **reference** for understanding game mechanics, not for direct compilation into your mod. You should:

- **Browse and study** the decompiled code to understand how Minecraft works
- **Write your own code** in `src/main/java/` that uses Fabric APIs
- **Use mixins** when you need to modify Minecraft's behavior

### 2. Compilation Issues Are Expected

The decompiled sources may not compile perfectly due to:
- Decompiler limitations and inaccuracies
- Missing type information
- Obfuscation artifacts
- API changes between decompilation and runtime

### 3. Don't Include Decompiled Sources in Your Mod JAR

Never include the decompiled `net/minecraft/*` sources in your mod distribution:
- It's legally questionable
- It will cause massive conflicts
- It's unnecessary (Minecraft provides its own code at runtime)

### 4. Use Fabric APIs Instead

Rather than depending on Minecraft internals directly, use Fabric APIs when possible:

```groovy
dependencies {
    // Fabric API provides stable, versioned access to game features
    modImplementation "net.fabricmc.fabric-api:fabric-api:${project.fabric_version}"
}
```

## Fixing Specific Errors

### GameProfile.name() vs getName()

If decompiled code uses:
```java
String name = gameProfile.name();
UUID id = gameProfile.id();
```

But you get errors, the actual API is:
```java
String name = gameProfile.getName();
UUID id = gameProfile.getId();
```

**Solution:** This is a decompilation artifact. In your own code, always use `getName()` and `getId()`.

### FabricProvidedTagBuilder Type Parameters

If you see:
```
error: cannot infer type arguments for FabricProvidedTagBuilder<>
```

The decompiled code might be missing generic type parameters. This is a decompiler issue and doesn't affect your mod development if you're using proper Fabric APIs.

### Type Inference Issues

Generic type issues in decompiled code are common. These don't affect:
- Your mod code in `src/main/java/`
- Your ability to reference and understand the decompiled code

If you absolutely need to fix these for IDE navigation, you can manually add type parameters in the decompiled files (though this is not recommended as it's a lot of work).

## Recommended Workflow

1. **Keep decompiled sources separate** - They live in `net/minecraft/` for reference
2. **Write your mod** in `src/main/java/com/yourmod/`
3. **Use Fabric APIs** from `fabric-api` dependency
4. **Use mixins** when you need to modify Minecraft behavior
5. **Reference decompiled sources** to understand what to mixin or how systems work

## Example Mod Structure

```
your-project/
├── src/
│   ├── main/java/com/yourmod/      ← Your mod code (compiles)
│   │   ├── YourMod.java
│   │   └── mixin/
│   │       └── YourMixin.java
│   └── main/resources/
│       ├── fabric.mod.json
│       └── yourmod.mixins.json
├── net/minecraft/                   ← Decompiled sources (reference only)
│   ├── client/
│   ├── server/
│   └── ...
└── build.gradle                     ← Your build config
```

## Still Having Issues?

If you're getting specific compilation errors:

1. **Check if you're compiling the right thing** - Your mod should only compile `src/`, not `net/`
2. **Verify your gradle configuration** - Make sure you're not including decompiled sources in your source sets
3. **Check your IDE** - IntelliJ/Eclipse might be indexing the decompiled sources incorrectly
4. **Review Fabric documentation** - https://fabricmc.net/wiki/

## Finding Correct Dependency Versions

To find the exact versions Minecraft uses:

1. Check Minecraft's libraries:
   - Windows: `%APPDATA%\.minecraft\libraries\`
   - Mac: `~/Library/Application Support/minecraft/libraries/`
   - Linux: `~/.minecraft/libraries/`

2. Look in the Minecraft version JSON:
   - Find it in `.minecraft/versions/1.21.*/1.21.*.json`
   - Search for library names and versions

3. Use Maven Central or libraries.minecraft.net to find compatible versions

## Summary

- Decompiled sources are **for reference**, not compilation
- Write your mod code in `src/main/java/`
- Use Fabric APIs instead of Minecraft internals when possible
- Add dependencies only if you're directly using Mojang libraries in your mod
- Don't try to fix all decompiler errors - focus on your mod's code

---

**For more help:**
- Fabric Discord: https://discord.gg/v6v4pMv
- Fabric Wiki: https://fabricmc.net/wiki/
- Fabric Documentation: https://docs.fabricmc.net/

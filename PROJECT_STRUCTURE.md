# Project Structure

## Current Directory Layout

```
MC1.21.10/
│
├── 📄 README.md                    # Main documentation
├── 📄 SETUP_GUIDE.md               # Detailed setup instructions
├── 📄 QUICK_START.md               # Quick reference guide
├── 📄 STATUS.md                    # Current project status
├── 📄 NETWORK_ACCESS_REQUEST.md    # IT access request template
├── 📄 PROJECT_STRUCTURE.md         # This file
│
├── 🔧 build.gradle                 # Gradle build configuration
├── 🔧 gradle.properties            # Version and configuration properties
├── 🔧 settings.gradle              # Gradle settings and repositories
├── 🔧 decompile-minecraft.gradle   # Custom decompilation script
│
├── 📜 check-network-access.sh      # Network connectivity checker
├── 📜 gradlew                      # Gradle wrapper (Unix)
├── 📜 gradlew.bat                  # Gradle wrapper (Windows)
│
├── 📁 gradle/                      # Gradle wrapper files
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
│
├── 📁 src/                         # Source code directory
│   ├── main/                       # Main mod source
│   │   ├── java/
│   │   │   └── com/example/
│   │   │       ├── ExampleMod.java           # Main mod class
│   │   │       └── mixin/
│   │   │           └── ExampleMixin.java     # Example mixin
│   │   └── resources/
│   │       ├── fabric.mod.json               # Mod metadata
│   │       ├── modid.mixins.json             # Mixin configuration
│   │       └── assets/
│   │           └── modid/
│   │               └── icon.png              # Mod icon
│   │
│   └── client/                     # Client-only code
│       ├── java/
│       │   └── com/example/
│       │       ├── ExampleModClient.java     # Client initialization
│       │       └── mixin/client/
│       │           └── ExampleClientMixin.java
│       └── resources/
│           └── modid.client.mixins.json      # Client mixin config
│
├── 📁 .gradle/                     # Gradle cache (generated)
├── 📁 build/                       # Build output (generated)
└── 📁 .idea/                       # IntelliJ IDEA settings
```

## After Source Extraction

Once `./gradlew extractMinecraftSources` is run successfully, the structure will expand to include:

```
MC1.21.10/
│
├── (all files above)
│
└── 📁 net/                         # Decompiled Minecraft sources
    └── minecraft/
        ├── client/                 # Client-side code
        │   ├── Minecraft.java
        │   ├── gui/
        │   ├── renderer/
        │   └── ...
        │
        ├── server/                 # Server-side code
        │   ├── MinecraftServer.java
        │   └── ...
        │
        ├── world/                  # World generation & management
        │   ├── World.java
        │   ├── biome/
        │   ├── chunk/
        │   └── ...
        │
        ├── entity/                 # Entity classes
        │   ├── Entity.java
        │   ├── player/
        │   ├── mob/
        │   └── ...
        │
        ├── item/                   # Item classes
        │   ├── Item.java
        │   ├── ItemStack.java
        │   └── ...
        │
        ├── block/                  # Block classes
        │   ├── Block.java
        │   ├── BlockState.java
        │   └── ...
        │
        └── (many more packages)
```

## Key Files Explained

### Configuration Files

| File | Purpose |
|------|---------|
| `build.gradle` | Main build script defining dependencies, tasks, and build logic |
| `gradle.properties` | Version numbers and JVM settings |
| `settings.gradle` | Repository locations and project name |

### Source Files

| File | Purpose |
|------|---------|
| `ExampleMod.java` | Main mod initialization (runs on both client and server) |
| `ExampleModClient.java` | Client-side initialization (runs only on client) |
| `ExampleMixin.java` | Example of code injection into Minecraft |
| `fabric.mod.json` | Mod metadata (name, version, dependencies, etc.) |

### Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Overview and main documentation |
| `SETUP_GUIDE.md` | Step-by-step setup instructions |
| `QUICK_START.md` | Quick reference for common tasks |
| `STATUS.md` | Current project status and progress |
| `NETWORK_ACCESS_REQUEST.md` | Template for requesting IT access |
| `PROJECT_STRUCTURE.md` | This file - explains project layout |

### Helper Scripts

| File | Purpose |
|------|---------|
| `check-network-access.sh` | Checks if required domains are accessible |
| `decompile-minecraft.gradle` | Alternative decompilation approach |
| `gradlew` / `gradlew.bat` | Platform-specific Gradle wrapper scripts |

## Build Artifacts (Generated)

These directories are created during the build process:

| Directory | Contents |
|-----------|----------|
| `.gradle/` | Gradle cache and downloaded dependencies |
| `build/` | Compiled classes and built JAR files |
| `run/` | Minecraft test environment |
| `logs/` | Build and runtime logs |

## Ignored Files

The `.gitignore` file prevents these from being committed:
- Build artifacts (`build/`, `.gradle/`)
- IDE settings (`.idea/`, `*.iml`)
- Runtime directories (`run/`, `logs/`)
- Compiled classes (`*.class`)
- Log files (`*.log`)

## Typical Workflow

1. **Edit** mod code in `src/main/java/` or `src/client/java/`
2. **Build** with `./gradlew build`
3. **Test** with `./gradlew runClient`
4. **Reference** Minecraft code in `net/minecraft/`
5. **Package** final mod is in `build/libs/`

## Mod Development Areas

| What You Want to Do | Look In |
|---------------------|---------|
| Add new items | `src/main/java/` - Study `net/minecraft/item/` |
| Add new blocks | `src/main/java/` - Study `net/minecraft/block/` |
| Add new entities | `src/main/java/` - Study `net/minecraft/entity/` |
| Modify GUI | `src/client/java/` - Study `net/minecraft/client/gui/` |
| Add custom rendering | `src/client/java/` - Study `net/minecraft/client/renderer/` |
| Modify game mechanics | Use mixins - Study examples in `src/main/java/.../mixin/` |

## Next Steps

1. Run `./check-network-access.sh` to verify domain access
2. Once access is granted, run `./gradlew genSources`
3. Run `./gradlew extractMinecraftSources`
4. Browse the decompiled Minecraft code in `net/minecraft/`
5. Start developing your mod in `src/main/java/`

## Questions?

- See `README.md` for overview
- See `SETUP_GUIDE.md` for detailed instructions
- See `QUICK_START.md` for quick commands
- Visit https://fabricmc.net/wiki for Fabric documentation

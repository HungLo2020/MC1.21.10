# Minecraft 1.21.10 Modding Project

This repository contains a Fabric modding project setup for Minecraft version 1.21.10.

## ⚠️ IMPORTANT: Client Sources Missing

**This repository currently contains only SERVER source code.** The client source code (GUI, rendering, etc.) is missing and needs to be added.

**→ See [ADD_CLIENT_SOURCES.md](ADD_CLIENT_SOURCES.md) for instructions on how to add the client sources.**

Quick fix:
```bash
./download-and-decompile-client.sh
```

## Prerequisites

- Java Development Kit (JDK) 21 or higher
- Gradle 8.5+ (included via Gradle Wrapper)

## Project Structure

```
MC1.21.10/
├── src/
│   ├── main/          # Main mod source code
│   └── client/        # Client-side mod code
├── build.gradle       # Gradle build configuration
├── gradle.properties  # Project properties and versions
├── settings.gradle    # Gradle settings
└── gradlew           # Gradle wrapper script
```

## Current Status

### ⚠️ Network Access Limitation

This project requires access to the following Maven repositories:
- `maven.fabricmc.net` - For Fabric Loom and Fabric API
- `launchermeta.mojang.com` - For Minecraft version manifests
- `piston-data.mojang.com` - For downloading Minecraft JARs

**These domains are currently not accessible in the build environment**, which prevents the automatic setup and decompilation of Minecraft sources.

## Setup Instructions

### Option 1: Request Domain Whitelist (Recommended)

Request access to the following domains:
1. `maven.fabricmc.net`
2. `launchermeta.mojang.com`
3. `piston-data.mojang.com`

Once access is granted, you can run:

```bash
./gradlew genSources
./gradlew extractMinecraftSources
```

This will:
1. Download Minecraft 1.21.10
2. Apply mappings
3. Decompile the source code
4. Extract decompiled sources to the project root directory

### Option 2: Manual Decompilation

If you have access to the Minecraft client JAR file:

1. Place the `minecraft-client-1.21.10.jar` file in the project root
2. Rename it to `minecraft-client.jar`
3. Run: `./gradlew -b decompile-minecraft.gradle decompileMinecraftJar`

### Option 3: Use a Local Maven Repository

If you have a local mirror or cache of the required dependencies:

1. Update `settings.gradle` to point to your local repository
2. Update `build.gradle` repositories section
3. Run the standard Gradle commands

## Project Configuration

### Versions (gradle.properties)

- **Minecraft**: 1.21.10
- **Fabric Loader**: 0.17.3
- **Fabric API**: 0.136.0+1.21.10
- **Fabric Loom**: 1.9.2
- **Java**: 21

### Gradle Tasks

Once the network access issues are resolved:

- `./gradlew build` - Build the mod
- `./gradlew runClient` - Run Minecraft with the mod
- `./gradlew genSources` - Generate decompiled Minecraft sources
- `./gradlew extractMinecraftSources` - Extract sources to project root

## Mod Development

The example mod structure is included:
- Main mod class: `src/main/java/com/example/ExampleMod.java`
- Client mod class: `src/client/java/com/example/ExampleModClient.java`
- Mod configuration: `src/main/resources/fabric.mod.json`

## Decompiled Sources

Once successfully decompiled, the Minecraft source code will be extracted to the root directory of this project, allowing you to:
- Browse Minecraft's internal code
- Reference vanilla implementations
- Understand game mechanics
- Create better mods

## Troubleshooting

### Build fails with "Could not resolve"

This indicates that the required Maven repositories are not accessible. Follow one of the setup options above.

### Java version mismatch

Ensure you're using Java 21. Check with: `java -version`

### Gradle daemon issues

Try: `./gradlew --stop` and then retry your command.

## Additional Resources

- [Fabric Documentation](https://fabricmc.net/wiki/)
- [Fabric API GitHub](https://github.com/FabricMC/fabric)
- [Fabric Discord](https://discord.gg/v6v4pMv)

## License

This is a modding project template. The Minecraft source code is proprietary to Mojang/Microsoft. Please respect their terms of service when modding.

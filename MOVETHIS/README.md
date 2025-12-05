# Decompiled Minecraft 1.21.10 Source Code

This folder contains the complete decompiled source code for Minecraft version 1.21.10.

## Contents

- **net/minecraft/** - Main Minecraft game code (~31MB)
  - All game mechanics, entities, blocks, items, etc.
  - Client and server code
  - World generation, rendering, UI, etc.

- **com/mojang/** - Mojang utility libraries (~76KB)
  - Math utilities and other helper classes

## Structure

```
MOVETHIS/
├── net/
│   └── minecraft/
│       ├── commands/       # Command system
│       ├── server/         # Server-side code
│       ├── client/         # Client-side code
│       ├── world/          # World generation and management
│       ├── entity/         # Entity classes
│       ├── block/          # Block classes
│       ├── item/           # Item classes
│       ├── network/        # Networking code
│       ├── core/           # Core game systems
│       └── ... (many more packages)
│
└── com/
    └── mojang/
        └── math/           # Math utilities

```

## Usage

This is the **complete decompiled Minecraft source code**. You can:

1. **Copy this entire folder** to your new project repository
2. Browse and reference the code for mod development
3. Understand vanilla Minecraft mechanics and implementations

## Important Notes

- ✅ **Decompiled with Mojang's official mappings** (readable variable/method names)
- ✅ **Complete source for Minecraft 1.21.10**
- ⚠️ **Do NOT redistribute this code** - respect Mojang's terms of service
- ⚠️ **For reference and mod development only**

## Decompilation Details

- **Minecraft Version**: 1.21.10
- **Mappings**: Mojang Official Mappings
- **Decompiler**: VineFlower (via Fabric Loom)
- **Total Size**: ~31MB

## Next Steps for Your Project

1. Copy this entire `MOVETHIS` folder to your new repository
2. You may want to rename it (e.g., to `minecraft-source` or just merge into your project root)
3. Add it to your `.gitignore` if you don't want to commit it (recommended)
4. Use it as a reference while developing your mod

---

**Generated**: December 5, 2025
**Source Repository**: MC1.21.10

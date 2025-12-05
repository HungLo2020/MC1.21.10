# 👋 START HERE

## ⚠️ IMPORTANT NOTICE

**This repository is missing CLIENT source code!** It currently only has server-side Minecraft code.

**YOU MUST ADD CLIENT SOURCES before you can fully develop mods.**

→ **Read [ADD_CLIENT_SOURCES.md](ADD_CLIENT_SOURCES.md) for complete instructions.**

Quick fix (requires network access):
```bash
./download-and-decompile-client.sh
```

---

## What Just Happened?

Your Minecraft 1.21.10 Fabric modding project has been **partially set up** with server sources only.

## 🎯 What You Need To Do NOW

### Step 1: Check Network Access (30 seconds)

Open a terminal in this directory and run:

```bash
./check-network-access.sh
```

This will check if your network allows access to the required domains.

### Step 2A: If All Domains Are Accessible ✅

Great! Complete the setup with these two commands:

```bash
# This downloads Minecraft and decompiles it (takes 5-10 minutes)
./gradlew genSources

# This extracts the decompiled code to your project (takes 1-2 minutes)
./gradlew extractMinecraftSources
```

**Done!** You now have the full Minecraft source code in your project root directory.

### Step 2B: If Domains Are Blocked ⚠️

You need to request access from your IT/network team:

1. **Share this file with them**: `NETWORK_ACCESS_REQUEST.md`
   - It explains what domains are needed and why
   - It confirms they're official Microsoft/Mojang domains
   - It's written for IT professionals

2. **Wait for approval** (usually takes 1-3 business days)

3. **Then run the commands from Step 2A**

## 📖 What Should You Read?

Depending on what you need:

| If You Want To... | Read This File |
|-------------------|----------------|
| Get started quickly | `QUICK_START.md` |
| Understand what's been set up | `SUMMARY.md` |
| Follow detailed instructions | `SETUP_GUIDE.md` |
| See the full project overview | `README.md` |
| Check current status | `STATUS.md` |
| Understand the file structure | `PROJECT_STRUCTURE.md` |
| Request IT access | `NETWORK_ACCESS_REQUEST.md` |

## ⏭️ What's Next?

After running the commands successfully:

1. **Browse Minecraft code**: Look in `net/minecraft/` folder
2. **Edit example mod**: Modify files in `src/main/java/com/example/`
3. **Test your mod**: Run `./gradlew runClient`
4. **Learn Fabric**: Visit https://fabricmc.net/wiki

## ❓ Quick FAQ

**Q: Why can't I just start coding my mod now?**
A: You can look at the example mod, but you won't be able to build or test it until dependencies are downloaded.

**Q: What if I don't have access to those domains?**
A: You have three options:
   1. Request access (recommended - see `NETWORK_ACCESS_REQUEST.md`)
   2. Use a different computer that has access, then transfer files
   3. Manually provide Minecraft JAR and use the alternative decompiler

**Q: How long will the setup take after I have network access?**
A: About 10-15 minutes total (mostly automated downloads and decompilation).

**Q: Will the Minecraft source code be included in my commits?**
A: You can choose - by default it's not ignored. See `.gitignore` for comments on excluding it.

**Q: Is this legal?**
A: Yes, decompiling Minecraft for mod development is allowed under Mojang's guidelines. Just don't redistribute the decompiled code.

## 🆘 Need Help?

1. Check the documentation files listed above
2. Run `./check-network-access.sh` to diagnose network issues
3. Visit Fabric Discord: https://discord.gg/v6v4pMv
4. Search Fabric Wiki: https://fabricmc.net/wiki

## ✨ Quick Tips

- Use IntelliJ IDEA (recommended) or VS Code for development
- The example mod in `src/main/java/com/example/` is a great starting point
- Mixins are powerful - study the examples in `src/main/java/com/example/mixin/`
- Always test with `./gradlew runClient` before releasing your mod

---

**Remember**: Run `./check-network-access.sh` first!

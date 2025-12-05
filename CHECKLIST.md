# Checklist: Adding Client Source Code

Use this checklist to track your progress in adding the missing client sources.

## Prerequisites ✓

- [ ] I have Java 21+ installed
  ```bash
  java -version
  ```

- [ ] I have curl or wget installed
  ```bash
  curl --version
  # OR
  wget --version
  ```

- [ ] I have network access to required domains
  ```bash
  ./check-network-access.sh
  ```
  Required domains:
  - launchermeta.mojang.com
  - piston-data.mojang.com
  - maven.fabricmc.net

## Running the Decompilation

- [ ] I pulled the latest changes
  ```bash
  git pull origin copilot/add-client-source-code
  ```

- [ ] I verified the script is executable
  ```bash
  ls -l download-and-decompile-client.sh
  # Should show: -rwxr-xr-x
  ```

- [ ] I ran the decompilation script
  ```bash
  ./download-and-decompile-client.sh
  ```
  Expected time: 5-15 minutes

- [ ] The script completed successfully
  - [ ] Downloaded version manifest
  - [ ] Downloaded client JAR
  - [ ] Ran genSources task
  - [ ] Extracted sources to repository
  - [ ] Updated MOVETHIS folder

## Verification

- [ ] Client directory exists
  ```bash
  ls -la net/minecraft/client/
  ```

- [ ] Client has reasonable number of files
  ```bash
  find net/minecraft/client -name "*.java" | wc -l
  # Expected: ~1,500-2,000 files
  ```

- [ ] Total files looks correct
  ```bash
  find net/minecraft -name "*.java" | wc -l
  # Expected: ~4,500+ files
  ```

- [ ] Key client files exist
  ```bash
  ls net/minecraft/client/Minecraft.java
  ls -d net/minecraft/client/gui/
  ls -d net/minecraft/client/renderer/
  ```

- [ ] MOVETHIS folder was updated
  ```bash
  ls -la MOVETHIS/net/minecraft/client/
  ```

## Committing Changes

- [ ] I reviewed what was added
  ```bash
  git status
  ```

- [ ] I added the new sources
  ```bash
  git add net/ MOVETHIS/
  ```

- [ ] I committed the changes
  ```bash
  git commit -m "Add Minecraft 1.21.10 client source code"
  ```

- [ ] I pushed to repository
  ```bash
  git push
  ```

## Optional: Testing

- [ ] I can build the project
  ```bash
  ./gradlew build
  ```

- [ ] I can run the client
  ```bash
  ./gradlew runClient
  ```

## Troubleshooting

If something went wrong, check:

- [ ] I read the error message carefully
- [ ] I checked `ADD_CLIENT_SOURCES.md` for solutions
- [ ] I verified network access with `./check-network-access.sh`
- [ ] I tried cleaning Gradle cache: `./gradlew clean`
- [ ] I tried removing Loom cache: `rm -rf .gradle/loom-cache`
- [ ] I considered alternative methods in `QUICK_FIX.md`

## All Done! 🎉

Once all items are checked:

✅ Repository now has both client and server source code  
✅ MOVETHIS folder is complete  
✅ Ready for mod development  

Next steps:
- Browse the decompiled sources in your IDE
- Start developing your mod in `src/main/java/`
- Reference Minecraft code as needed
- Read Fabric documentation: https://fabricmc.net/wiki

---

**Need help?** See:
- `INSTRUCTIONS_FOR_USER.md` - Detailed instructions
- `ADD_CLIENT_SOURCES.md` - Complete guide
- `QUICK_FIX.md` - Quick solutions

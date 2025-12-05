# Fix: Version Not Found Error

## Error Message
```
ERROR: Could not find Minecraft 1.21.10 in version manifest
```

## Quick Diagnosis

Run the test script:
```bash
./test-version-lookup.sh
```

This will show you:
- ✓ If version 1.21.10 exists in Mojang's manifest
- 📋 List of available recent Minecraft versions
- 🔍 What the actual version number should be

## Common Causes

### 1. Version Doesn't Exist with that Name

Minecraft versions sometimes have confusing naming:
- `1.21.1` exists (major.minor.patch)
- `1.21.10` might not exist (could be confused with 1.21.1.0)

**Fix:** Run `./test-version-lookup.sh` to see available versions, then update `gradle.properties`:
```properties
minecraft_version=1.21.1
```
(or whatever version is actually available)

### 2. Version Not Yet Released

If you're trying to use a future or beta version:
- Check if it's a snapshot (like `24w14a`)
- Check if it's a release candidate (like `1.21-rc1`)

**Fix:** Use a stable release version

### 3. Version Recently Removed

Older versions sometimes get removed from the manifest.

**Fix:** Use a more recent stable version

## Solution Steps

### Step 1: Run Diagnostic
```bash
./test-version-lookup.sh
```

### Step 2: Check Output
The script will show something like:
```
Recent Minecraft versions in manifest:
------------------------------------------------------------
 1. 1.21.4              (release)
 2. 1.21.3              (release)
 3. 1.21.2              (release)
 4. 1.21.1              (release) ← MATCH!
 5. 1.21                (release)
...
```

### Step 3: Update gradle.properties

If your version isn't found, pick a valid one from the list:

```bash
# Edit gradle.properties
nano gradle.properties

# Change this line:
minecraft_version=1.21.10

# To a valid version like:
minecraft_version=1.21.1
```

### Step 4: Update Related Files

If you change the Minecraft version, you may also need to update:

**gradle.properties:**
```properties
minecraft_version=1.21.1        # ← Update this
fabric_version=0.92.2+1.21.1   # ← And this (check fabricmc.net)
```

To find the correct Fabric API version:
1. Visit: https://fabricmc.net/develop/
2. Select your Minecraft version
3. Copy the Fabric API version shown

### Step 5: Retry Download
```bash
./download-and-decompile-client.sh
```

## Alternative: Use Specific Version in Script

If you don't want to change gradle.properties, you can edit the script directly:

```bash
# Edit download-and-decompile-client.sh
nano download-and-decompile-client.sh

# Find this line near the top:
MC_VERSION="1.21.10"

# Change to:
MC_VERSION="1.21.1"

# Save and retry
./download-and-decompile-client.sh
```

## Verify Version Exists

Before trying again, verify the version exists:

### Online Check
Visit: https://mcversions.net/

### Command Line Check
```bash
curl -s https://launchermeta.mojang.com/mc/game/version_manifest_v2.json | grep -o '"id":"1.21[^"]*"' | head -20
```

## Still Having Issues?

### Double-Check Version Format
- ✅ Correct: `1.21.1`, `1.21`, `1.20.4`
- ❌ Wrong: `1.21.10` (if it doesn't exist)
- ❌ Wrong: `v1.21.1` (no 'v' prefix)
- ❌ Wrong: `1.21.1.0` (not usually used)

### Check Repository README
The repository name is `MC1.21.10` but that doesn't mean version 1.21.10 exists.
It might be a typo or naming choice. Use the actual available version.

### Use Latest Stable
When in doubt, use the latest stable release:
1. Run `./test-version-lookup.sh`
2. Look at the first "release" type version in the list
3. Use that version

## Summary

**Problem:** Version string doesn't match Mojang's manifest  
**Solution:** Run test script, find correct version, update gradle.properties  
**Script:** `./test-version-lookup.sh`  

---

**Quick Commands:**
```bash
# 1. Diagnose
./test-version-lookup.sh

# 2. Update version in gradle.properties
nano gradle.properties

# 3. Retry
./download-and-decompile-client.sh
```

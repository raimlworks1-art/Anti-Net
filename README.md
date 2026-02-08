# Anti-Net

A runtime remote decryption system for Roblox with universal support.

## Overview

Anti-Net automatically discovers and decrypts runtime remotes with obfuscated/hidden names by analyzing garbage collection data and remote handlers. Works universally across different Roblox games.

## Features

- **Automatic Handler Detection** - Finds `GetEventHandler` and `GetFunctionHandler` automatically
- **Universal Compatibility** - Works across different games without modification
- **Targeted Decryption** - Optional path-based decryption for specific folders
- **Progress Logging** - Real-time status updates during decryption
- **Yielding Support** - Optional yielding to prevent performance issues

## Installation

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/raimlworks1-art/Anti-Net/refs/heads/main/Main.luau"))()
```

## Configuration

Configure Anti-Net before execution:

```lua
getgenv().Config = {
    Yielding = false,  -- Enable yielding every 100 functions (prevents lag)
    Runtime = true,    -- Must be true - enables runtime decryption
    Path = nil,        -- Optional: Instance path to specific folder
    Id = 0            -- Reserved for future use
}
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Yielding` | Boolean | `false` | Yields every 100 functions to prevent performance issues |
| `Runtime` | Boolean | `true` | **Required** - Enables runtime decryption |
| `Path` | Instance | `nil` | Decrypt remotes in a specific folder only |
| `Id` | Number | `0` | Reserved (not yet implemented) |

## Usage

### Basic Usage

```lua
-- Configure (optional - uses defaults if not set)
getgenv().Config = {
    Yielding = false,
    Runtime = true
}

-- Load and run
local Net = loadstring(game:HttpGet("https://raw.githubusercontent.com/raimlworks1-art/Anti-Net/refs/heads/main/Main.luau"))()
```

### Targeted Decryption

```lua
-- Decrypt remotes in a specific folder
getgenv().Config = {
    Runtime = true,
    Path = game.ReplicatedStorage.RemotesFolder
}

local Net = loadstring(game:HttpGet("https://raw.githubusercontent.com/raimlworks1-art/Anti-Net/refs/heads/main/Main.luau"))()
```

### Manual Decryption

```lua
local Net = require(script.AntiNet)
local Functions, Remotes = Net.Decrypt()
```

## How It Works

1. **Scans garbage collection** for remote handler functions
2. **Extracts handler tables** containing remote references
3. **Maps obfuscated names** to actual remote instances
4. **Renames remotes** to their original handler names

## API

### `Net.Decrypt()`

Executes the decryption process.

**Returns:**
- `Functions` - Function handler table
- `Remotes` - Remote event handler table

**Example:**
```lua
local Funcs, Remotes = Net.Decrypt()
```

## Logging

Anti-Net uses an integrated logging system with the following levels:

- **S** (Success) - Operation completed successfully
- **W** (Warning) - Non-critical issues
- **F** (Failure) - Critical errors

## Requirements

- Roblox exploit with `getgc()`, `debug.info()`, and `getupvalue()` support
- Script execution capability

## Notes

- `Runtime` must always be `true`
- If `Path` is set, only remotes within that folder are decrypted
- Yielding is recommended for games with many functions (>1000)

## Author

**Rai**

## License

This project is provided as-is for educational purposes.

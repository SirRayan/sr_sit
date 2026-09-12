# 🪑 sr_sit — Advanced Prop Seating System

[![FiveM](https://img.shields.io/badge/FiveM-Resource-orange.svg)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-blue.svg)](https://www.lua.org/)
[![ox_lib](https://img.shields.io/badge/Dependency-ox__lib-informational.svg)](https://github.com/overextended/ox_lib)
[![ox_target](https://img.shields.io/badge/Dependency-ox__target-informational.svg)](https://github.com/overextended/ox_target)

**sr_sit** is a lightweight, modern, and highly optimized seating system for FiveM. It allows players to seamlessly sit on benches, chairs, sofas, stools, and various seating props across Los Santos using **ox_target**.

Featuring smart seat detection, multi-seat prop support (e.g., long benches or sectionals), entity occupancy checks, full multilingual localization (`ox_lib` locales), and smooth animations, `sr_sit` provides a polished roleplay experience without sacrificing server performance.

---

## ✨ Features

- 🎯 **Target Interaction**: Integrated with `ox_target` for a clean, immersive third-eye interaction.
- 🪑 **Multi-Seat Support**: Intelligently handles multi-person seating props (benches, couches, etc.) by routing players to the closest available seat.
- 🚫 **Smart Occupancy Detection**: Checks both nearby players and NPCs to ensure no two peds sit in the exact same spot.
- 🌐 **Full Localization (Locales)**: Native `ox_lib` multi-language support (English & Arabic included out of the box).
- 📐 **250+ Pre-Configured Props**: Pre-mapped with accurate offsets (`vec4` positions & headings) for over 250 GTA V chair and bench models.
- 🎮 **Configurable Keybind**: Stand up seamlessly using a customizable keybind (Default: **`X`**), registered through FiveM's native keymapping system via `ox_lib`.
- 🎥 **Smooth Camera Experience**: Automatically disables camera collision with the chair while seated to avoid awkward camera glitches.
- 🔄 **Safe Position Restoration**: Saves the player's exact original coordinates and restores them cleanly when standing up.
- 🛡️ **Resource Cleanup**: Gracefully detaches and unfreezes the player if the resource restarts or stops.
- ⚡ **Optimized Performance**: **0.00 ms** idle consumption; only runs minimal logic during interaction.

---

## 📋 Requirements & Dependencies

To run `sr_sit`, ensure the following resources are installed and started **before** `sr_sit`:

1. [**ox_lib**](https://github.com/overextended/ox_lib/releases) — Core utility library (used for notifications, TextUI, nearby checks, locales, and keybinding).
2. [**ox_target**](https://github.com/overextended/ox_target/releases) — Target interaction system.

---

## 🚀 Installation

1. **Download & Extract**:
   - Download the latest release or clone the repository.
   - Place the `sr_sit` folder inside your FiveM server's `resources` directory (e.g., `resources/[scripts]/sr_sit`).

2. **Configure your `server.cfg`**:
   Ensure `ox_lib` and `ox_target` start **before** `sr_sit`:
   ```cfg
   ensure ox_lib
   ensure ox_target
   ensure sr_sit
   ```

3. **Restart the Server** or run `ensure sr_sit` in your server console.

---

## 🎮 How to Use

1. **Sitting Down**:
   - Walk up to any supported chair, bench, or sofa.
   - Hold your `ox_target` key (Default: `Left ALT`).
   - Hover over the chair and select **Sit** (Chair icon).
   - Your character will automatically sit in the closest available position.

2. **Standing Up**:
   - Press **`X`** (default keybind).
   - Your character will stand up and return to their previous position.
   - *Note*: Players can rebind the key at any time in **Settings > Key Bindings > FiveM > Stand up**.

---

## ⚙️ Configuration & Customization

### General Configuration
All core script options can be customized in:
📂 `config/config.lua`

```lua
return {
    ---Specify the language code (e.g., 'en', 'ar').
    ---Leave nil or '' to automatically use ox_lib's default (setr ox:locale in server.cfg).
    ---If neither is specified, it defaults to English ('en').
    Language = nil,

    ---Enable or disable debug logs in F8 console
    Debug = false,

    ---Target interaction settings
    Target = {
        icon = 'fa-solid fa-chair',
        distance = 1.5,
    },

    ---TextUI prompt position ('right-center', 'top-center', 'left-center', etc.)
    TextUIPosition = 'right-center',

    ---Default key to stand up from a seat
    DefaultKey = 'X',
}
```

### Adding New Chairs / Models
All supported models and seat offsets are located in:
📂 `config/models.lua`

You can add custom chair props or tweak existing offsets by adding the model hash and its seat coordinates:

```lua
return {
    -- Single seat example:
    -- [ModelHash] = { vec4(offsetX, offsetY, offsetZ, heading) }
    [-2065455377] = { vec4(0.0, -0.1, 0.5, 180.0) },

    -- Multi-seat bench example (multiple vec4 entries for each seat):
    [-1877459292] = {
        vec4(-1.25, -0.6, 0.5, 270.0),
        vec4(-0.5, 0.4, 0.5, 180.0),
        vec4(0.5, 0.4, 0.5, 180.0),
        vec4(1.5, 0.4, 0.5, 180.0)
    },
}
```

### 🌐 Localization & Languages (Locales)
`sr_sit` supports `ox_lib`'s built-in localization system with English and Arabic translations included out of the box:

- 🇬🇧 **English**: `locales/en.json`
- 🇸🇦 **Arabic**: `locales/ar.json`

#### Language Selection Hierarchy:
1. **`Config.Language`** in `config/config.lua` (if specified, e.g., `'ar'` or `'en'`).
2. Global **`ox:locale`** convar set in `server.cfg` (e.g., `setr ox:locale "ar"`).
3. Fallback to English (**`'en'`**) if neither is specified.

> [!NOTE]
> In `locales/ar.json`, the keybinding description is kept as `"Stand up"` because GTA V's native keybindings menu does not support Arabic fonts and will render Arabic characters as empty boxes (`□□□□`).

---

## 📊 Performance

| State | Resmon Usage |
|---|---|
| **Idle** | `0.00 ms` |
| **Seated** | `0.00 ms` - `0.01 ms` |

---

## 👤 Author

Developed by **[SirRayan](https://github.com/)**

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) (or your preferred open-source license). Feel free to modify and adapt it for your server!

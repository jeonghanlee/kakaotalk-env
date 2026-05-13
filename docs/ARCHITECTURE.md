# kakaotalk-env Architecture

## Scope

This document covers the repository structure, setup flow, Wine runtime paths, and Makefile variable scoping for KakaoTalk installation through Wine.

**Out of scope:** KakaoTalk account management, KakaoTalk protocol behavior, and Wine internals.

## Overview

`kakaotalk-env` provides a small Makefile-driven workflow and Bash wrapper for installing, starting, stopping, and uninstalling KakaoTalk under Wine on Debian-family Linux systems.

## Provisioning Flow

```text
scripts/UpdateWine4Debian.bash
        |
        v
WineHQ repository + required font packages
        |
        v
make setup
        |
        +--> download KakaoTalk_Setup.exe
        +--> update Wine shell font mapping
        +--> stop running KakaoTalk process
        +--> run installer through wine
```

## Directory Structure

```text
kakaotalk-env/
├── Makefile                         # Entry point
├── configure/
│   ├── CONFIG                       # Configuration aggregator
│   ├── RELEASE                      # Project identity and upstream URL
│   ├── CONFIG_SITE                  # Site-overridable runtime settings
│   ├── CONFIG_VARS                  # Derived tool variables
│   ├── RULES                        # Rule aggregator
│   ├── RULES_FUNC                   # Shared Makefile controls
│   ├── RULES_KAKAOTALK              # KakaoTalk workflow targets
│   └── RULES_VARS                   # Variable inspection targets
├── kakaotalk.bash                   # Runtime start, stop, uninstall wrapper
├── scripts/
│   ├── UpdateWine4Debian.bash       # Current Debian WineHQ setup helper
│   ├── updateWine4Debian11.bash     # Debian 11-specific helper
│   └── updateWine4Debian12.bash     # Debian 12-specific helper
├── docs/                            # Technical documentation
└── images/                          # Setup screenshots
```

## Network / Inventory

| Endpoint | Purpose | Source |
|---|---|---|
| `http://app.pc.kakao.com/talk/win32/KakaoTalk_Setup.exe` | KakaoTalk installer download | `configure/RELEASE` |
| `https://dl.winehq.org/wine-builds/winehq.key` | WineHQ archive key | `scripts/UpdateWine4Debian.bash` |
| `https://dl.winehq.org/wine-builds/debian/dists/<codename>/winehq-<codename>.sources` | WineHQ Debian source file | `scripts/UpdateWine4Debian.bash` |

## Component Architecture

| Component | Responsibility |
|---|---|
| `Makefile` | Defines `TOP` and includes `configure/CONFIG` and `configure/RULES` |
| `configure/RELEASE` | Defines installer name, source URL, and source version label |
| `configure/CONFIG_SITE` | Defines Wine registry path, default font, and changelog filename |
| `configure/CONFIG_VARS` | Defines derived paths such as the KakaoTalk wrapper script |
| `configure/RULES_KAKAOTALK` | Implements download, install, font configuration, process control, and cleanup targets |
| `configure/RULES_VARS` | Prints active Makefile variables for inspection |
| `kakaotalk.bash` | Finds the installed Wine path and controls KakaoTalk runtime commands |
| `scripts/UpdateWine4Debian.bash` | Installs WineHQ repository configuration and required Debian packages |

## OS / Platform Differences

| Concern | Debian 11 | Debian 12 | Debian 13 / current helper |
|---|---|---|---|
| WineHQ source selection | Fixed `bullseye` helper | Fixed `bookworm` helper | Uses `VERSION_CODENAME` from `/etc/os-release` |
| Repository key handling | Legacy `apt-key` helper | `/etc/apt/keyrings` | `/etc/apt/keyrings` |
| Default workflow | Compatibility helper | Compatibility helper | `scripts/UpdateWine4Debian.bash` |

## Variable Scoping

| Scope | File | Contents |
|---|---|---|
| Project identity | `configure/RELEASE` | `APPNAME`, `SRC_BASE_URL`, `SRC_NAME`, `SRC_URL`, `SRC_VERSION` |
| Site overrides | `configure/CONFIG_SITE` | `WINE_CFG`, `DEFAULT_FONT`, `MD_FILE` |
| Derived variables | `configure/CONFIG_VARS` | `KAKAOTALK_CTL` |
| Rule controls | `configure/RULES_FUNC` | `QUIET`, optional `DEBUG_SHELL` behavior |
| Workflow rules | `configure/RULES_KAKAOTALK` | `help`, `setup`, `upgrade`, `get`, `conf`, `install`, `start`, `stop` |

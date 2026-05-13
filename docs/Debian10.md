# Debian 10 Wine Compatibility Note

## Scope

This document covers the Debian 10 Wine compatibility issue observed with KakaoTalk PC version 3.1.7.2601 and later.

**Out of scope:** Current Debian 12 and Debian 13 setup. Use `scripts/UpdateWine4Debian.bash` for current Debian systems.

## Observed Error

On Debian 10 with the default Wine package, KakaoTalk may fail during startup with:

```text
err:module:LdrInitializeThunk "Vox.dll" failed to initialize, aborting
```

The application may then consume CPU without opening its user interface.

## WineHQ Development Package

Use the WineHQ repository instead of the Debian-provided Wine package for this legacy Debian 10 case. The WineHQ Debian instructions are the authoritative source:

```text
https://wiki.winehq.org/Debian
```

Legacy Debian 10 command sequence:

```bash
wget -nc https://dl.winehq.org/wine-builds/winehq.key
```

```bash
apt-key add winehq.key
```

```bash
printf "%s\n" "deb https://dl.winehq.org/wine-builds/debian/ buster main" > /etc/apt/sources.list.d/winehq.list
```

```bash
apt update
```

```bash
apt install --install-recommends winehq-devel
```

## Reinstall

After the Wine package is updated, reinstall KakaoTalk:

```bash
make upgrade
```

Check the Wine version:

```bash
wine --version
```

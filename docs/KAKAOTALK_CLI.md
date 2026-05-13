# KakaoTalk Command Reference

## Wine Setup

```bash
bash scripts/UpdateWine4Debian.bash
```

Installs required packages, adds the WineHQ Debian repository for the detected Debian codename, updates apt metadata, and installs `winehq-stable`.

---

## Makefile Inspection

```bash
make help
```

Shows available Makefile targets.

```bash
make vars
```

Prints active Makefile variables.

```bash
make vars FILTER=APP
```

Prints active Makefile variables with names beginning with `APP`.

```bash
make check
```

Runs Bash syntax validation, runs ShellCheck when available, and verifies Makefile variable inspection.

---

## Installer Workflow

```bash
make get
```

Runs the backup step and downloads `KakaoTalk_Setup.exe`.

```bash
make setup
```

Runs the full install workflow.

```bash
make upgrade
```

Downloads the installer, applies Wine font configuration, stops KakaoTalk if it is running, and runs the installer.

```bash
make install
```

Runs the downloaded installer through Wine.

---

## Wine Font Configuration

```bash
make conf
```

Updates `MS Shell Dlg` and `MS Shell Dlg 2` in the Wine registry file.

```bash
make conf.show
```

Shows the Wine shell font entries.

---

## Runtime Control

```bash
make start
```

Starts KakaoTalk through `kakaotalk.bash`.

```bash
make stop
```

Stops the running KakaoTalk process.

```bash
make uninstall
```

Runs the KakaoTalk uninstaller through Wine.

---

## Direct Wrapper Commands

```bash
bash kakaotalk.bash start
```

```bash
bash kakaotalk.bash stop
```

```bash
bash kakaotalk.bash restart
```

```bash
bash kakaotalk.bash uninstall
```

```bash
bash kakaotalk.bash ip
```

```bash
bash kakaotalk.bash dbg
```

---

## Maintenance

```bash
make clean
```

Removes the downloaded KakaoTalk installer.

```bash
make backup
```

Renames an existing installer with the version extracted from `ChangeLogs_en.md`.

---

## Makefile Wrappers

```bash
make start
```

Equivalent to:

```bash
bash kakaotalk.bash start
```

```bash
make stop
```

Equivalent to:

```bash
bash kakaotalk.bash stop
```

```bash
make uninstall
```

Equivalent to:

```bash
bash kakaotalk.bash uninstall
```

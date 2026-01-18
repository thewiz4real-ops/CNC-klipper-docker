# Klipper + Moonraker + Mainsail (Docker on Windows 11 / WSL2)

This folder contains the Docker Compose stack for running:
- **Klipper** (firmware host)
- **Moonraker** (API)
- **Mainsail** (Web UI)

Target setup:
- **Windows 11**
- **Docker Desktop** (WSL2 backend)

---

## What’s in this folder

- `docker-compose.yaml` — main stack
- `docker-compose.override.example.yml` — example overrides (ports + USB device pass-through)
- `mainsail-config.json` — tells Mainsail which Moonraker host/port to use
- `.env.example` — optional env template (if you use it)
- `scripts/` — helper scripts for Windows + WSL checks

---

## Ports

- Mainsail UI: **http://localhost:8999**
- Moonraker API: **http://localhost:7126**

---

## 1) First-time setup

### A) Copy the override file
From **this `docker/` folder**:

```sh
cp docker-compose.override.example.yml docker-compose.override.yml
```

Edit `docker-compose.override.yml` if needed (ports + your USB device path).

---

## 2) Attach your controller USB to WSL (Docker Desktop)

### A) List USB devices (PowerShell as Admin)
```powershell
usbipd list
```

Find your controller in the list and note its **BUSID** (example: `1-9`).

### B) Bind it (PowerShell as Admin)
```powershell
usbipd bind --busid <BUSID>
```

### C) Attach it to Docker’s WSL distro (PowerShell as Admin)

**If your usbipd supports `attach --wsl --distribution`:**
```powershell
usbipd attach --wsl --distribution docker-desktop --busid <BUSID> --auto-attach
```

**If you get** `Unrecognized command or argument 'docker-desktop'`  
you are on the *older* usbipd syntax — use this instead:
```powershell
usbipd wsl attach --distribution docker-desktop --busid <BUSID> --auto-attach
```

### D) Verify the device exists inside docker-desktop
```powershell
wsl -d docker-desktop -- sh -lc "ls -l /dev/serial/by-id/ || ls -l /dev/ttyACM* /dev/ttyUSB*"
```

---

## 3) Set your MCU serial in Klipper

Your Klipper config is mounted inside the container as:
`/opt/printer_data/config/printer.cfg`

On the host (repo-level), you normally edit it here:
`../printer_data/config/printer.cfg`

Inside `printer.cfg`, set:

```ini
[mcu]
serial: /dev/serial/by-id/<YOUR-DEVICE-HERE>
```

---

## 4) Start / Stop the stack

From `docker/`:

```sh
docker compose up -d
docker compose ps
```

Stop everything:

```sh
docker compose down
```

If you want a full cleanup:

```sh
docker compose down --remove-orphans
```

---

## Useful debug commands

### Check containers
```sh
docker compose ps
```

### Mainsail / Moonraker / Klipper logs
```sh
docker compose logs -f mainsail
docker compose logs -f moonraker
docker compose logs -f klipper
```

### Klipper log (most important)
```sh
docker compose exec klipper sh -lc 'tail -n 200 /opt/printer_data/logs/klippy.log'
```

### Check Klipper socket (should exist when Klipper is up)
```sh
docker compose exec klipper sh -lc 'ls -l /opt/printer_data/run/klipper.sock'
```

### Check USB inside the Klipper container
```sh
docker compose exec klipper sh -lc 'ls -l /dev/serial/by-id/ || ls -l /dev/ttyACM* /dev/ttyUSB*'
```

---

## Common “it loads but won’t connect” causes

- The USB device is **not attached** to `docker-desktop` (fix with `usbipd attach`)
- The `serial:` path in `[mcu]` does not match what’s inside `/dev/serial/by-id/`
- Only one container is running (usually means override file wasn’t applied or compose failed)

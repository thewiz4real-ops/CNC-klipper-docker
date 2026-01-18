# CNC Klipper + Moonraker + Mainsail (Docker on Windows 11 / WSL2)

Run a **Klipper-based CNC controller stack** on a Windows 11 machine using **Docker Desktop (WSL2 backend)**:

- **Klipper** (firmware host)
- **Moonraker** (API)
- **Mainsail** (Web UI)

This repo also includes:
- **Klipper + Moonraker config** for a CNC-style setup (no heaters/extruder)
- **CAD + 3D printed parts**
- **Hardware BOM**
- Project docs + videos

---

## Repo map

| What | Where |
|---|---|
| Docker stack (Compose + helper scripts) | [`docker/`](docker/README.md) |
| Klipper + Moonraker config (mounted into containers) | [`printer_data/config/`](printer_data/config/README.md) |
| Documentation (start here) | [`docs/`](docs/README.md) |
| Bill of Materials | [`hardware/BOM/`](hardware/BOM/README.md) |
| CAD + 3D printed parts | [`cad/`](cad/README.md) |

---

## Quick start

### Prereqs

- Windows 11
- Docker Desktop (**WSL2 backend enabled**)
- `usbipd-win` (to attach a USB MCU/controller into the `docker-desktop` WSL distro)

### 0) Clone the repo (example path)

In WSL (Ubuntu), many people keep this stack in `~/klipstack`:

```sh
mkdir -p ~/klipstack
cd ~/klipstack
# git clone https://github.com/<YOUR-USER>/<YOUR-REPO>.git .
```

> If you clone into some other folder, just substitute the paths below.

### 1) Configure Docker Compose

From the `docker/` folder:

```sh
cd docker
cp docker-compose.override.example.yml docker-compose.override.yml
```

Optional (naming the Compose project):

```sh
cp .env.example .env
```

Edit `docker-compose.override.yml` if needed (ports + USB device pass-through).

### 2) Attach your USB controller to Docker’s WSL distro

PowerShell (Admin):

```powershell
usbipd list
usbipd bind --busid <BUSID>

# Newer syntax
usbipd attach --wsl --distribution docker-desktop --busid <BUSID> --auto-attach

# Older syntax (if the line above fails)
usbipd wsl attach --distribution docker-desktop --busid <BUSID> --auto-attach
```

Verify inside `docker-desktop`:

```powershell
wsl -d docker-desktop -- sh -lc "ls -l /dev/serial/by-id/ || ls -l /dev/ttyACM* /dev/ttyUSB*"
```

(Helper scripts live in [`docker/scripts/`](docker/scripts/).)

### 3) Set your MCU serial in Klipper

**In this repo**, the host file you edit is:

- [`printer_data/config/printer.cfg`](printer_data/config/printer.cfg)

So if you cloned into `~/klipstack`, that’s:

```sh
nano ~/klipstack/printer_data/config/printer.cfg
```

Inside `printer.cfg`, set:

```ini
[mcu]
serial: /dev/serial/by-id/<YOUR-DEVICE-HERE>
```

**Inside the container**, that same file is mounted at:

- `/opt/printer_data/config/printer.cfg`

**Optional convenience:** if you prefer editing it as `~/klipstack/config/printer.cfg`, you can make a symlink:

```sh
cd ~/klipstack
ln -s printer_data/config config
nano config/printer.cfg
```

### 4) Start / Stop the stack

From `docker/`:

```sh
docker compose up -d
docker compose ps
```

Open:

- Mainsail UI: http://localhost:8999
- Moonraker API: http://localhost:7126

Stop:

```sh
docker compose down
```

---

## Config files

- Moonraker: [`printer_data/config/moonraker.conf`](printer_data/config/moonraker.conf)
- Klipper: [`printer_data/config/printer.cfg`](printer_data/config/printer.cfg)

> Note: this is a CNC-oriented config (no heaters/extruder).

---

## Hardware BOM

- Quick view: [`hardware/BOM/README.md`](hardware/BOM/README.md)
- CSV (for spreadsheet import): [`hardware/BOM/BOM.csv`](hardware/BOM/BOM.csv)

---

## CAD + printed parts

See: [`cad/README.md`](cad/README.md)

---

## Docs + videos

Start here: [`docs/README.md`](docs/README.md)

- Intro: [`docs/00-intro.md`](docs/00-intro.md)
- Troubleshooting: [`docs/07-troubleshooting.md`](docs/07-troubleshooting.md)

---

## License

MIT — see [`LICENSE`](LICENSE).

---

## Full file index

<details>
<summary>Click to expand</summary>

#### Repo root
- [`.gitignore`](.gitignore)
- [`LICENSE`](LICENSE)
- [`README.md`](README.md)

#### docker
- [`docker/.env.example`](docker/.env.example)
- [`docker/README.md`](docker/README.md)
- [`docker/docker-compose.override.example.yml`](docker/docker-compose.override.example.yml)
- [`docker/docker-compose.yaml`](docker/docker-compose.yaml)
- [`docker/mainsail-config.json`](docker/mainsail-config.json)
- [`docker/scripts/verify_docker_desktop_device.ps1`](docker/scripts/verify_docker_desktop_device.ps1)
- [`docker/scripts/windows_attach_usb.ps1`](docker/scripts/windows_attach_usb.ps1)
- [`docker/scripts/windows_list_usb.ps1`](docker/scripts/windows_list_usb.ps1)
- [`docker/scripts/wsl_verify_devices.sh`](docker/scripts/wsl_verify_devices.sh)

#### printer_data
- [`printer_data/config/README.md`](printer_data/config/README.md)
- [`printer_data/config/moonraker.conf`](printer_data/config/moonraker.conf)
- [`printer_data/config/printer.cfg`](printer_data/config/printer.cfg)
- [`printer_data/config/savevars_only.cfg`](printer_data/config/savevars_only.cfg)

#### docs
- [`docs/00-intro.md`](docs/00-intro.md)
- [`docs/07-troubleshooting.md`](docs/07-troubleshooting.md)
- [`docs/board-skr-mini-e3-v3.md`](docs/board-skr-mini-e3-v3.md)
- [`docs/README.md`](docs/README.md)

#### hardware
- [`hardware/BOM/BOM.csv`](hardware/BOM/BOM.csv)
- [`hardware/BOM/README.md`](hardware/BOM/README.md)

#### cad
- [`cad/3d_printed_parts/CNC Prob holder.3mf`](cad/3d_printed_parts/CNC%20Prob%20holder.3mf)
- [`cad/3d_printed_parts/CNC Spindle speed control potentiometer box.3mf`](cad/3d_printed_parts/CNC%20Spindle%20speed%20control%20potentiometer%20box.3mf)
- [`cad/3d_printed_parts/CNC Z axis.3mf`](cad/3d_printed_parts/CNC%20Z%20axis.3mf)
- [`cad/3d_printed_parts/CNC cable chain support.3mf`](cad/3d_printed_parts/CNC%20cable%20chain%20support.3mf)
- [`cad/3d_printed_parts/CNC cable corner.3mf`](cad/3d_printed_parts/CNC%20cable%20corner.3mf)
- [`cad/3d_printed_parts/SKRMiniBox CNC.3mf`](cad/3d_printed_parts/SKRMiniBox%20CNC.3mf)
- [`cad/README.md`](cad/README.md)
- [`cad/source/fusion360/.gitkeep`](cad/source/fusion360/.gitkeep)
- [`cad/source/fusion360/CNC Prob holder.f3d`](cad/source/fusion360/CNC%20Prob%20holder.f3d)
- [`cad/source/fusion360/CNC Spindle speed control potentiometer box.f3d`](cad/source/fusion360/CNC%20Spindle%20speed%20control%20potentiometer%20box.f3d)
- [`cad/source/fusion360/CNC Z axis.f3d`](cad/source/fusion360/CNC%20Z%20axis.f3d)
- [`cad/source/fusion360/CNC cable chain support.f3d`](cad/source/fusion360/CNC%20cable%20chain%20support.f3d)
- [`cad/source/fusion360/CNC cable corner.f3d`](cad/source/fusion360/CNC%20cable%20corner.f3d)
- [`cad/source/fusion360/SKRMiniBox CNC.f3d`](cad/source/fusion360/SKRMiniBox%20CNC.f3d)

</details>
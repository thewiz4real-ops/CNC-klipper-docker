# SKR Mini E3 V3.0 — Klipper flashing + USB power jumper

This page documents how I flash Klipper to a **BIGTREETECH SKR Mini E3 V3.0** and the one small hardware detail that trips people up: the **USB power jumper**.

## Flashing Klipper (microSD method)
The SKR Mini E3 V3.0 is typically flashed via **microSD**.

1) **Configure + build Klipper**

```sh
cd ~/klipper
make menuconfig
make clean
make
```

2) **Copy firmware to microSD**

- File to copy: `~/klipper/out/klipper.bin`
- Rename it to: `firmware.bin`
- Put it on the **root** of a **FAT32** microSD card

3) **Flash the board**

- Power **OFF** the board
- Insert the microSD card
- Power **ON** the board

After a successful flash, the board will often rename the file to something like `FIRMWARE.CUR` / `firmware.cur`.

## Recommended `make menuconfig` settings (SKR Mini E3 V3.0)
Typical settings:

- **Micro-controller Architecture:** `STM32`
- **Processor model:** `STM32G0B1`
- **Bootloader offset:** `8KiB`
- **Clock Reference:** `8 MHz`
- **Communication interface:**
  - Choose **USB (PA11/PA12)** if you connect the host via USB (most common)
  - Choose **USART** only if you are wiring UART instead of USB

> Note: The exact menu labels can vary slightly across Klipper versions, but the key bits for this board are the `STM32G0B1` MCU and the `8KiB` bootloader offset.

## USB power jumper (only if you want USB-only power)
If you plug the board into USB and **nothing powers up** (no LEDs) and you are **not** using the machine PSU, you likely need the **USB power jumper** installed.

- It’s usually a small 2‑pin jumper cap near the USB connector.
- Silkscreen labels vary, commonly: `SW_USB`, `USB_PWR`, `5V_USB`.

### When to use it
- **Bench setup / flashing / testing with USB power only** → install the jumper

### When NOT to use it
- If the board is powered from the machine PSU, you usually **don’t need** the jumper.
- Avoid having multiple power sources “fighting” (USB + PSU) if your wiring/power path can backfeed.

## Finding the device path after flashing (Linux / WSL)
Once flashed and connected by USB, find the serial device path:

```sh
ls -l /dev/serial/by-id/
```

Then set it in your Klipper config:

- Repo file: `printer_data/config/printer.cfg`

Example:

```ini
[mcu]
serial: /dev/serial/by-id/<YOUR-DEVICE-HERE>
```

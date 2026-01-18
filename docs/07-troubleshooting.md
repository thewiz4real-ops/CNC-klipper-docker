# Troubleshooting

## USB device not found
- Re-run `usbipd list`
- Re-attach using the new BUSID
- Verify inside docker-desktop: `ls -l /dev/serial/by-id/`

## Klipper disconnected
- Check `/opt/printer_data/logs/klippy.log`
- Confirm the MCU path in `[mcu] serial:`

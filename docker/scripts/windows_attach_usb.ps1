param(
  [Parameter(Mandatory=$true)][string]$BusId
)

usbipd bind --busid $BusId
try {
  usbipd attach --wsl --distribution docker-desktop --busid $BusId --auto-attach
} catch {
  usbipd wsl attach --distribution docker-desktop --busid $BusId --auto-attach
}

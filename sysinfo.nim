

when defined(windows):
  import winreg, osproc, strutils, osinfo/win

  proc getMachineGuid*(): string =
    getStrValue(r"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography\MachineGuid")

  proc getOsName*(): string =
    getStrValue(r"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName")

  proc getOsVersion*(): string =
    getStrValue(r"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentVersion")

  proc getCpuName*(): string =
    getStrValue(r"HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0\ProcessorNameString")

  proc getCpuGhz*(): float =
    getInt32Value(r"HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0\~MHz").float / 1000.0

  proc getFreeMemroy*(): int64 =
    getMemoryInfo().AvailablePhysMem


when isMainModule:
  echo "MachineGuid: ", getMachineGuid()
  echo "OsName: ", getOsName()
  echo "OsVersion: ", getOsVersion()
  echo "CpuName: ", getCpuName()
  echo "CpuGhz: ", getCpuGhz(), "GHz"
  echo "FreeMemroy: ", getFreeMemroy().float / 1024 / 1024 / 1024, "GB"
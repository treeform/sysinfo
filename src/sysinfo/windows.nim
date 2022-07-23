import common, strutils, osproc

proc wmic(sub, key: string): string =
  let (outp, _) = execCmdEx("wmic " & sub & " get " & key)
  return outp.strip().split("\n")[^1].strip()

proc getMachineGuid*(): string =
  wmic("path win32_computersystemproduct", "uuid")

proc getMachineModel*(): string =
  wmic("computersystem", "model")

proc getMachineName*(): string =
  wmic("computersystem", "name")

proc getMachineManufacturer*(): string =
  wmic("computersystem", "manufacturer")

proc getOsName*(): string =
    wmic("os", "Name").split("|")[0]

proc getOsVersion*(): string =
  wmic("os", "Version")

proc getOsSerialNumber*(): string =
  wmic("os", "SerialNumber")

proc getCpuName*(): string =
  wmic("cpu", "Name")

proc getCpuManufacturer*(): string =
  wmic("cpu", "manufacturer")

proc getNumCpus*(): int =
  tryParseInt wmic("computersystem", "NumberOfProcessors")

proc getNumTotalCores*(): int =
  tryParseInt wmic("computersystem", "NumberOfLogicalProcessors")

proc getCpuGhz*(): float =
  parseFloat(wmic("cpu", "MaxClockSpeed")) / 1000.0

proc getTotalMemory*(): uint64 =
  uint64 tryParseInt wmic("computersystem", "TotalPhysicalMemory")

proc getFreeMemory*(): uint64 =
  uint64 tryParseInt wmic("os", "FreePhysicalMemory")

proc getGpuName*(): string =
  wmic("path win32_VideoController", "name")

proc getGpuDriverVersion*(): string =
  wmic("path win32_VideoController", "DriverVersion")

proc getGpuMaxFPS*(): int =
  tryParseInt wmic("path win32_VideoController", "MaxRefreshRate")

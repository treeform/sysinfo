import common, strutils

proc cat(sub, key: string): string =
  for line in readFile(sub).split("\n"):
    if line.startsWith(key):
      return line.split(":")[^1].strip()

proc getMachineGuid*(): string =
  readFile("/sys/devices/virtual/dmi/id/product_uuid").strip()

proc getMachineModel*(): string =
  readFile("/sys/devices/virtual/dmi/id/product_name").strip()

proc getMachineName*(): string =
  ""

proc getMachineManufacturer*(): string =
  readFile("/sys/devices/virtual/dmi/id/product_name").strip().split(" ")[0]

proc getOsName*(): string =
  for line in readFile("/etc/os-release").split("\n"):
    if line.startsWith("NAME="):
      return line[6..^2]

proc getOsVersion*(): string =
  for line in readFile("/etc/os-release").split("\n"):
    if line.startsWith("VERSION_ID="):
      return line[12..^2]

proc getOsSerialNumber*(): string =
  readFile("/sys/devices/virtual/dmi/id/product_serial").strip()

proc getCpuName*(): string =
  cat("/proc/cpuinfo", "model name")

proc getCpuManufacturer*(): string =
  cat("/proc/cpuinfo", "vendor_id")

proc getNumCpus*(): int =
  readFile("/proc/cpuinfo").count("processor")

proc getNumTotalCores*(): int =
  tryParseInt(cat("/proc/cpuinfo", "cpu cores")) * getNumCpus()

proc getCpuGhz*(): float =
  return parseFloat cat("/proc/cpuinfo", "cpu MHz")

proc getTotalMemory*(): uint64 =
  return uint64 tryParseInt(cat("/proc/meminfo", "MemTotal").split(" ")[0]) * 1024

proc getFreeMemory*(): uint64 =
  return uint64 tryParseInt(cat("/proc/meminfo", "MemFree").split(" ")[0]) * 1024

proc getGpuName*(): string =
  ""

proc getGpuDriverVersion*(): string =
  ""

proc getGpuMaxFPS*(): int =
  -1

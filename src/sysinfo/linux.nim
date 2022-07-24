import common, std/strutils, std/osproc, std/math

proc cat(sub, key: string): string =
  try:
    let data = readFile(sub)
    for line in data.split("\n"):
      if line.startsWith(key):
        return line.split(":")[^1].strip()
  except:
    discard

proc getMachineGuid*(): string =
  try:
    return readFile("/etc/machine-id").strip()
  except:
    discard

proc getMachineModel*(): string =
  try:
    return readFile("/sys/devices/virtual/dmi/id/product_name").strip()
  except:
    discard

proc getMachineName*(): string =
  try:
    return readFile("/etc/hostname").strip()
  except:
    discard

proc getMachineManufacturer*(): string =
  try:
    return readFile("/sys/devices/virtual/dmi/id/product_name").strip()
  except:
    discard

proc getOsName*(): string =
  try:
    for line in readFile("/etc/os-release").split("\n"):
      if line.startsWith("NAME="):
        return line[5..^1].strip(chars={'"', '\''})
  except:
    discard

proc getOsVersion*(): string =
  try:
    for line in readFile("/etc/os-release").split("\n"):
      if line.startsWith("VERSION_ID="):
        return line[11..^1].strip(chars={'"', '\''})
  except:
    discard

proc getOsSerialNumber*(): string =
  try:
    return readFile("/sys/devices/virtual/dmi/id/product_serial").strip()
  except:
    discard

proc getCpuName*(): string =
  cat("/proc/cpuinfo", "model name")

proc getCpuManufacturer*(): string =
  cat("/proc/cpuinfo", "vendor_id")

proc getNumCpus*(): int =
  try:
    for line in readFile("/proc/cpuinfo").split("\n"):
      if "physical id" in line:
        result = max(result, tryParseInt(line.split(":", 1)[1].strip()))
    inc result
  except:
    discard

proc getNumTotalCores*(): int =
  try:
    return tryParseInt(cat("/proc/cpuinfo", "cpu cores"))
  except:
    discard

proc getCpuGhz*(): float =
  try:
    return parseFloat cat("/proc/cpuinfo", "cpu MHz")
  except:
    discard

proc getTotalMemory*(): uint64 =
  try:
    let data = cat("/proc/meminfo", "MemTotal").split(" ")[0]
    return uint64 tryParseInt(data) * 1024
  except:
    discard

proc getFreeMemory*(): uint64 =
  try:
    let data = cat("/proc/meminfo", "MemFree").split(" ")[0]
    return uint64 tryParseInt(data) * 1024
  except:
    discard

proc getGpuName*(): string =
  try:
    let (output, _) = execCmdEx("glxinfo -B")
    for line in output.split("\n"):
      if line.startsWith("    Device: "):
        return line[12 ..< line.find(" (")]
  except:
    discard

proc getGpuDriverVersion*(): string =
  try:
    let (output, _) = execCmdEx("glxinfo -B")
    for line in output.split("\n"):
      if line.startsWith("    Version: "):
        return line[13 .. ^1]
  except:
    discard

proc getGpuMaxFPS*(): int =
  try:
    let (output, _) = execCmdEx("xrandr")
    for line in output.split("\n"):
      if line.startsWith("   "):
        return tryParseFloat(line.splitWhitespace()[1]).ceil().int
  except:
    discard

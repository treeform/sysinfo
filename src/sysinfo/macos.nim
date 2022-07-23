import common, strutils, osproc, tables

var cache = newTable[string, string]()
proc systemProfiler(sub, key: string): string =
  if sub notin cache:
    let (outp, _) = execCmdEx("system_profiler " & sub)
    cache[sub] = outp
  for rawLine in cache[sub].splitLines():
    var line = rawLine.strip()
    if line.startsWith(key):
      return line[len(key)..^1]

proc systemProfilerM(sub, key: string): seq[string] =
  if sub notin cache:
    let (outp, _) = execCmdEx("system_profiler " & sub)
    cache[sub] = outp
  for rawLine in cache[sub].splitLines():
    var line = rawLine.strip()
    if line.startsWith(key):
      result.add line[len(key)..^1]

proc getMachineGuid*(): string =
  systemProfiler("SPHardwareDataType", "Hardware UUID: ")

proc getMachineModel*(): string =
  systemProfiler("SPHardwareDataType", "Model Identifier: ")

proc getMachineName*(): string =
  ""

proc getMachineManufacturer*(): string =
  ""

proc getOsName*(): string =
  let (outp, _) = execCmdEx("sw_vers -productName")
  return outp.strip()

proc getOsVersion*(): string =
  let (outp, _) = execCmdEx("sw_vers -productVersion")
  return outp.strip()

proc getOsSerialNumber*(): string =
  systemProfiler("SPHardwareDataType", "Serial Number (system)")

proc getCpuName*(): string =
  systemProfiler("SPHardwareDataType", "Processor Name: ")

proc getCpuManufacturer*(): string =
  systemProfiler("SPHardwareDataType", "Processor Name: ").split(" ")[0]

proc getNumCpus*(): int =
  tryParseInt(systemProfiler("SPHardwareDataType", "Number of Processors: "))

proc getNumTotalCores*(): int =
  tryParseInt(systemProfiler("SPHardwareDataType", "Total Number of Cores: "))

proc getCpuGhz*(): float =
  let cpuStr = systemProfiler("SPHardwareDataType", "Processor Speed: ")
  if cpuStr != "":
    return parseFloat(cpuStr.split(" ")[0])

proc getTotalMemory*(): uint64 =
  let memStr = systemProfiler("SPHardwareDataType", "Memory: ")
  if memStr != "":
    return uint64(parseFloat(memStr.split(" ")[0]) * 1024 * 1024 * 1024)

proc getFreeMemory*(): uint64 =
  0
  # let (outp, _) = execCmdEx("vm_stat")
  # proc vmStat(key: string): string =
  #   for rawLine in outp.splitLines():
  #     echo rawLine
  #     var line = rawLine.strip()
  #     if line.startsWith(key):
  #       return line[len(key)..^1]
  # let scaleStr = vmStat("Mach Virtual Memory Statistics: (page size of ")
  # if scaleStr != "":
  #   let scale = uint64(tryParseInt(scaleStr.split(" ")[0]))
  #   return uint64(tryParseInt(vmStat("Pages free:  ")[0..^2].strip())) * scale

proc getGpuName*(): string =
  systemProfilerM("SPDisplaysDataType", "Chipset Model: ").join(", ")

proc getGpuDriverVersion*(): string =
  systemProfilerM("SPDisplaysDataType", "EFI Driver Version: ").join(", ")

proc getGpuMaxFPS*(): int =
  tryParseInt systemProfiler("SPDisplaysDataType", "UI Looks like:").split("@ ")[^1].split(" ")[0]

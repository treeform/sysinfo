

when defined(windows):
  import osproc, strutils

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
    parseInt wmic("computersystem", "NumberOfProcessors")

  proc getNumTotalCores*(): int =
    parseInt wmic("computersystem", "NumberOfLogicalProcessors")

  proc getCpuGhz*(): float =
    parseFloat(wmic("cpu", "MaxClockSpeed")) / 1000.0

  proc getTotalMemory*(): uint64 =
    uint64 parseInt wmic("computersystem", "TotalPhysicalMemory")

  proc getFreeMemory*(): uint64 =
    uint64 parseInt wmic("os", "FreePhysicalMemory")

  proc getGpuName*(): string =
    wmic("path win32_VideoController", "name")

  proc getGpuDriverVersion*(): string =
    wmic("path win32_VideoController", "DriverVersion")

  proc getGpuMaxFPS*(): int =
    parseInt wmic("path win32_VideoController", "MaxRefreshRate")


when defined(osx):
  import osproc, strutils

  proc systemProfiler(key: string): string =
    let (outp, _) = execCmdEx("system_profiler SPHardwareDataType")
    for rawLine in outp.splitLines():
      var line = rawLine.strip()
      if line.startsWith(key):
        return line[len(key)..^1]

  proc getMachineGuid*(): string =
    systemProfiler("Hardware UUID: ")

  proc getMachineModel*(): string =
    systemProfiler("Model Identifier: ")

  proc getOsName*(): string =
    let (outp, _) = execCmdEx("sw_vers -productName")
    return outp.strip()

  proc getOsVersion*(): string =
    let (outp, _) = execCmdEx("sw_vers -productVersion")
    return outp.strip()

  proc getCpuName*(): string =
    systemProfiler("Processor Name: ")

  proc getNumCpus*(): int =
    parseInt(systemProfiler("Number of Processors: "))

  proc getNumTotalCores*(): int =
    parseInt(systemProfiler("Total Number of Cores: "))

  proc getCpuGhz*(): float =
    let cpuStr = systemProfiler("Processor Speed: ")
    if cpuStr != "":
      return parseFloat(cpuStr.split(" ")[0])

  proc getTotalMemory*(): uint64 =
    let memStr = systemProfiler("Memory: ")
    if memStr != "":
      return uint64(parseFloat(memStr.split(" ")[0]) * 1024 * 1024 * 1024)

  proc getFreeMemory*(): uint64 =
    let (outp, _) = execCmdEx("vm_stat")
    proc vmStat(key: string): string =
      for rawLine in outp.splitLines():
        echo rawLine
        var line = rawLine.strip()
        if line.startsWith(key):
          return line[len(key)..^1]
    let scaleStr = vmStat("Mach Virtual Memory Statistics: (page size of ")
    if scaleStr != "":
      let scale = uint64(parseInt(scaleStr.split(" ")[0]))
      return uint64(parseInt(vmStat("Pages free:  ")[0..^2].strip())) * scale

when defined(linux):

  proc getMachineGuid*(): string =
    ""

  proc getMachineModel*(): string =
    ""

  proc getMachineName*(): string =
    ""

  proc getMachineManufacturer*(): string =
    ""

  proc getOsName*(): string =
    ""

  proc getOsVersion*(): string =
    ""

  proc getOsSerialNumber*(): string =
    ""

  proc getCpuName*(): string =
    ""

  proc getCpuManufacturer*(): string =
    ""

  proc getNumCpus*(): int =
    -1

  proc getNumTotalCores*(): int =
    -1

  proc getCpuGhz*(): float =
    0

  proc getTotalMemory*(): uint64 =
    0

  proc getFreeMemory*(): uint64 =
    0
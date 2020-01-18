

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
  import osproc, strutils, tables

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
    parseInt(systemProfiler("SPHardwareDataType", "Number of Processors: "))

  proc getNumTotalCores*(): int =
    parseInt(systemProfiler("SPHardwareDataType", "Total Number of Cores: "))

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
    #   let scale = uint64(parseInt(scaleStr.split(" ")[0]))
    #   return uint64(parseInt(vmStat("Pages free:  ")[0..^2].strip())) * scale

  proc getGpuName*(): string =
    systemProfilerM("SPDisplaysDataType", "Chipset Model: ").join(", ")

  proc getGpuDriverVersion*(): string =
    systemProfilerM("SPDisplaysDataType", "EFI Driver Version: ").join(", ")

  proc getGpuMaxFPS*(): int =
    parseInt systemProfiler("SPDisplaysDataType", "UI Looks like:").split("@ ")[^1].split(" ")[0]

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

  proc getGpuName*(): string =
    ""

  proc getGpuDriverVersion*(): string =
    ""

  proc getGpuMaxFPS*(): int =
    -1


when defined(windows):
  import sysinfo/winreg, osproc, strutils, osinfo/win

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

  proc getFreeMemory*(): uint64 =
    getMemoryInfo().AvailablePhysMem

when defined(osx):
  import osproc, strutils

  proc systemProfilerKey(key: string): string =
    let (outp, _) = execCmdEx("system_profiler SPHardwareDataType")
    for rawLine in outp.splitLines():
      var line = rawLine.strip()
      if line.startsWith(key):
        return line[len(key)..^1]

  proc getMachineGuid*(): string =
    systemProfilerKey("Hardware UUID: ")

  proc getMachineModel*(): string =
    systemProfilerKey("Model Identifier: ")

  proc getOsName*(): string =
    let (outp, _) = execCmdEx("sw_vers -productName")
    return outp.strip()

  proc getOsVersion*(): string =
    let (outp, _) = execCmdEx("sw_vers -productVersion")
    return outp.strip()

  proc getCpuName*(): string =
    systemProfilerKey("Processor Name: ")

  proc getNumCpus*(): int =
    parseInt(systemProfilerKey("Number of Processors: "))

  proc getNumTotalCores*(): int =
    parseInt(systemProfilerKey("Total Number of Cores: "))

  proc getCpuGhz*(): float =
    let cpuStr = systemProfilerKey("Processor Speed: ")
    if cpuStr != "":
      return parseFloat(cpuStr.split(" ")[0])

  proc getTotalMemory*(): uint64 =
    let memStr = systemProfilerKey("Memory: ")
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


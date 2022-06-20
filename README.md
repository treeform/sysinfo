# Sysinfo

`nimble install sysinfo`

![Github Actions](https://github.com/treeform/sysinfo/workflows/Github%20Actions/badge.svg)

[API reference](https://nimdocs.com/treeform/sysinfo)

This library has no dependencies other than the Nim standard library.

## About

Cross-platform way to find common system resources like, os, os version, machine name, cpu stats...

## Supported platforms:

* Windows
* macOS
* Linux

## Example:

```nim
import sysinfo
echo "getMachineModel: ", getMachineModel()
echo "getMachineName: ", getMachineName()
echo "getMachineManufacturer: ", getMachineManufacturer()
echo "getOsName: ", getOsName()
echo "getOsVersion: ", getOsVersion()
echo "getCpuName: ", getCpuName()
echo "getCpuGhz: ", getCpuGhz(), "GHz"
echo "getCpuManufacturer: ", getCpuManufacturer()
echo "getNumCpus: ", getNumCpus()
echo "getNumTotalCores: ", getNumTotalCores()
echo "getTotalMemory: ", getTotalMemory().float / 1024 / 1024 / 1024, "GB"
echo "getFreeMemory: ", getFreeMemory().float / 1024 / 1024 / 1024, "GB"
echo "getGpuName: ", getGPUName()
echo "getGpuDriverVersion: ", getGpuDriverVersion()
echo "getGpuMaxFPS: ", getGpuMaxFPS()
```

```
getMachineModel: Z270P-D3
getMachineName: DESKTOP-V5LP96H
getMachineManufacturer: Gigabyte Technology Co., Ltd.
getOsName: Microsoft Windows 10 Pro
getOsVersion: 10.0.15063
getCpuName: Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz
getCpuGhz: 4.001GHz
getCpuManufacturer: GenuineIntel
getNumCpus: 1
getNumTotalCores: 8
getTotalMemory: 15.96039962768555GB
getFreeMemory: 0.008630607277154923GB
getGpuName: NVIDIA GeForce GTX 1080
getGpuDriverVersion: 25.21.14.1771
getGpuMaxFPS: 143
```

import ../src/sysinfo

#echo "getMachineGuid: ", getMachineGuid()
echo "getMachineModel: ", getMachineModel()
echo "getMachineName: ", getMachineName()
echo "getMachineManufacturer: ", getMachineManufacturer()
echo "getOsName: ", getOsName()
echo "getOsVersion: ", getOsVersion()
#echo "getOsSerialNumber: ", getOsSerialNumber()
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

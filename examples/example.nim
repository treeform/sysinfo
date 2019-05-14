import ../src/sysinfo


echo "getMachineGuid: ", getMachineGuid()
echo "getMachineModel: ", getMachineModel()
echo "getOsName: ", getOsName()
echo "getOsVersion: ", getOsVersion()
echo "getCpuName: ", getCpuName()
echo "getCpuGhz: ", getCpuGhz(), "GHz"
echo "getNumCpus: ", getNumCpus()
echo "getNumTotalCores: ", getNumTotalCores()
echo "getTotalMemory: ", getTotalMemory().float / 1024 / 1024 / 1024, "GB"
echo "getFreeMemory: ", getFreeMemory().float / 1024 / 1024 / 1024, "GB"
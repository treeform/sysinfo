# Taken from here: https://github.com/Araq/nimedit/blob/master/registry.nim

import winlean, os, strutils

type
  HKEY* = uint

const
  HKEY_CLASSES_ROOT* =     HKEY(0x80000000u)
  HKEY_CURRENT_USER* =     HKEY(0x80000001u)
  HKEY_LOCAL_MACHINE* =    HKEY(0x80000002u)
  HKEY_USERS* =            HKEY(0x80000003u)
  HKEY_PERFORMANCE_DATA* = HKEY(0x80000004u)
  HKEY_CURRENT_CONFIG* =   HKEY(0x80000005u)
  HKEY_DYN_DATA* =         HKEY(0x80000006u)

  RRF_RT_ANY = 0x0000ffff
  KEY_WOW64_64KEY = 0x0100
  KEY_WOW64_32KEY = 0x0200

  REG_SZ = 1
  REG_BINARY = 3

when false:
  const
    REG_NONE = 0
    REG_EXPAND_SZ = 2
    REG_DWORD = 4
    REG_DWORD_LITTLE_ENDIAN = 4
    REG_DWORD_BIG_ENDIAN = 5
    REG_LINK = 6
    REG_MULTI_SZ = 7
    REG_RESOURCE_LIST = 8
    REG_FULL_RESOURCE_DESCRIPTOR = 9
    REG_RESOURCE_REQUIREMENTS_LIST = 10
    REG_QWORD = 11
    REG_QWORD_LITTLE_ENDIAN = 11

proc regConnectRegistry(lpMachineName: WideCString, hKey: HKEY, phkResult: var HKEY): int32 {.importc: "RegConnectRegistryW", dynlib: "Advapi32.dll", stdcall.}
proc regCloseKey(hkey: HKEY): int32 {.importc: "RegCloseKey", dynlib: "Advapi32.dll", stdcall.}
proc regGetValue(key: HKEY, lpSubKey, lpValue: WideCString; dwFlags: int32 = RRF_RT_ANY, pdwType: ptr int32, pvData: pointer, pcbData: ptr int32): int32 {.importc: "RegGetValueW", dynlib: "Advapi32.dll", stdcall.}
proc regSetValue(hKey: HKEY, lpSubKey: WideCString, dwType: int32, lpData: pointer, cbData: int32): int32 {.importc: "RegSetValueW", dynlib: "Advapi32.dll", stdcall.}
proc regSetValueEx(hKey: HKEY, lpValueName: WideCString, reserved: int32, dwType: int32, lpData: pointer, cbData: int32): int32 {.importc: "RegSetValueExW", dynlib: "Advapi32.dll", stdcall.}

template call(f) =
  let err = f
  if err != 0:
    raiseOSError(err.OSErrorCode, "")

proc handleFromStr(key: string): HKEY =
  case key
  of "HKEY_CLASSES_ROOT": return HKEY_CLASSES_ROOT
  of "HKEY_CURRENT_USER": return HKEY_CURRENT_USER
  of "HKEY_LOCAL_MACHINE": return HKEY_LOCAL_MACHINE
  of "HKEY_USERS": return HKEY_USERS
  of "HKEY_PERFORMANCE_DATA": return HKEY_PERFORMANCE_DATA
  of "HKEY_CURRENT_CONFIG": return HKEY_CURRENT_CONFIG
  of "HKEY_DYN_DATA": return HKEY_DYN_DATA
  else: raise newException(ValueError, "Invalid reg path, must start with HKEY")


proc splitHandle(key: string): (HKEY, WideCString) =
  let arr = key.split(r"\", 1)
  let handle = handleFromStr(arr[0])
  return (handle, newWideCString(arr[1]))

proc setStrValue*(key, value: string) =
  let (handle, shortKey) = splitHandle(key)
  call regSetValue(handle, shortKey, REG_SZ, cast[pointer](newWideCString value), value.len.int32*2)

proc setBlobValue*(key, value: string) =
  let (handle, shortKey) = splitHandle(key)
  call regSetValueEx(handle, shortKey, 0, REG_BINARY, cast[pointer](cstring(value)), value.len.int32)

proc setBlobValue*(key: string, value: pointer; valueLen: Natural) =
  let (handle, shortKey) = splitHandle(key)
  call regSetValueEx(handle, shortKey, 0, REG_BINARY, value, valueLen.int32)


proc reg(key: string, data: pointer, size: ptr int32) =
  let (a, b) = os.splitPath(key)
  let arr = a.split(r"\", 1)
  assert arr.len == 2
  let handle = handleFromStr(arr[0])
  let hh = newWideCString arr[1]
  let kk = newWideCString b
  var bufsize: int32
  var flags: int32 = RRF_RT_ANY
  call regGetValue(handle, hh, kk, flags, nil, data, size)


proc getStrValue*(key: string): string =
  var bufsize: int32
  reg(key, nil, addr bufsize)
  var res = newWideCString("", bufsize)
  reg(key, cast[pointer](res), addr bufsize)
  result = res $ bufsize


proc getInt32Value*(key: string): int =
  var bufsize: int32
  reg(key, nil, addr bufsize)
  var data: int32
  reg(key, addr data, addr bufsize)
  return data


proc getUnicodeValue*(key: string; handle: HKEY = HKEY_CURRENT_USER): string =
  let (a, b) = os.splitPath(key)
  let hh = newWideCString a
  let kk = newWideCString b
  var bufsize: int32
  # try a couple of different flag settings:
  var flags: int32 = RRF_RT_ANY
  call regGetValue(handle, hh, kk, flags, nil, nil, addr bufsize)
  var res = newWideCString("", bufsize)
  call regGetValue(handle, hh, kk, flags, nil, cast[pointer](res),
                 addr bufsize)
  result = res $ bufsize


when isMainModule:
  #let x = open()
  setStrValue(r"HKEY_CURRENT_USER\Software\TestAndreas\ProductKey", "abc")
  echo getStrValue(r"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography\MachineGuid")
  echo "get str value"
  echo getStrValue(r"HKEY_CURRENT_USER\Software\TestAndreas\ProductKey\")

  #echo getUnicodeValue(r"hardware\acpi\facs\00000000") #, HKEY_CURRENT_USER)
  #discard stdin.readline()
  #echo getUnicodeValue(r"Software\Microsoft\Windows\CurrentVersion\GameInstaller")
 #   HKEY_CURRENT_USER)
  #var data = [64'u8, 65'u8, 66'u8]
  #setBlobValue(r"Software\TestAndreas\ProductID", addr data, 3)
  #echo getBlobValue(r"Software\TestAndreas\ProductID")

  #echo getUnicodeValue(r"Software\Microsoft\Windows\CurrentVersion\DigitalProductId")
#  echo getUnicodeValue(r"SOFTWARE\Wow6432Node\Microsoft\Cryptography\MachineGuid")
  #echo getValue(r"Software\Wow6432Node\7-Zip\Path")
  #x.close
# ===============================
# XPLOIT OPTIMIZER (XPLT v2)
# ===============================

$ultimate = (powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61) 2>&1

# Obtener GUID del plan activo (el duplicado o existente)
$guid = (powercfg -getactivescheme) -match '([a-f0-9-]{36})' | Out-Null
$guid = $matches[1]

# Activar explícitamente el plan
powercfg -setactive $guid

# CPU
powercfg -setacvalueindex $guid SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setacvalueindex $guid SUB_PROCESSOR PROCTHROTTLEMAX 99
powercfg -setacvalueindex $guid SUB_PROCESSOR PERFBOOSTMODE 2
powercfg -setacvalueindex $guid SUB_PROCESSOR SYSCOOLPOL 1
powercfg -setacvalueindex $guid SUB_PROCESSOR IDLEDISABLE 1

# PCIe / USB / disco
powercfg -setacvalueindex $guid SUB_PCIEXPRESS ASPM 0
powercfg -setacvalueindex $guid SUB_USB USBSELECTIVE 0
powercfg -setacvalueindex $guid SUB_DISK DISKIDLE 0

# Red
powercfg -setacvalueindex $guid SUB_NETPOWERSETTING NETWORKADAPTERPOWER 0

# Suspensión
powercfg -setacvalueindex $guid SUB_SLEEP STANDBYIDLE 0
powercfg -setacvalueindex $guid SUB_SLEEP HIBERNATEIDLE 0
powercfg -setacvalueindex $guid SUB_SLEEP HYBRIDSLEEP 0

# Re-aplicar plan
powercfg -setactive $guid

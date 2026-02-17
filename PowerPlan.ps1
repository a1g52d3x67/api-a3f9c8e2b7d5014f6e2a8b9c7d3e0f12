# ===============================
# XPLOIT OPTIMIZER (XPLT v2)
# ===============================

$UltimateGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"

# Crear plan basado en Ultimate
$output = powercfg -duplicatescheme $UltimateGUID 2>&1

if ($output -match "([a-f0-9\-]{36})") {
    $NewGUID = $matches[1]

    # Renombrar y añadir descripción
    powercfg -changename $NewGUID "Xploit Optimizer (XPLT v2)" "Plan de energia agresivo para +FPS"

    # Activarlo
    powercfg -setactive $NewGUID

    # Tweaks
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1

    powercfg -setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0
    powercfg -setacvalueindex SCHEME_CURRENT SUB_USB USBSELECTIVE 0
    powercfg -setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0
    powercfg -setacvalueindex SCHEME_CURRENT SUB_NETPOWERSETTING NETWORKADAPTERPOWER 0

    powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
    powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0
    powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0

    # Aplicar cambios finales
    powercfg -S $NewGUID

    Write-Host ""
    Write-Host "Xploit Optimizer (XPLT v2) ACTIVADO correctamente." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "Error al crear el plan." -ForegroundColor Red
}

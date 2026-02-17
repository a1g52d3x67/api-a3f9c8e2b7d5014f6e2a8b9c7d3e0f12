$UltimateGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"

# Crear plan basado en Ultimate Performance
$output = powercfg -duplicatescheme $UltimateGUID 2>&1

if ($output -match "([a-f0-9\-]{36})") {
    $NewGUID = $matches[1]

    powercfg -changename $NewGUID "Xploit Optimizer (XPLT v3)" "Plan EXTREMO sin ahorro ni limites"

    powercfg -setactive $NewGUID

    # ===============================
    # CPU FULL PERFORMANCE
    # ===============================

    # Min y Max al 100% para evitar lock a 2.40
    powercfg -setacvalueindex $NewGUID SUB_PROCESSOR PROCTHROTTLEMIN 100
    powercfg -setacvalueindex $NewGUID SUB_PROCESSOR PROCTHROTTLEMAX 100

    # Boost agresivo
    powercfg -setacvalueindex $NewGUID SUB_PROCESSOR PERFBOOSTMODE 2

    # Desactivar ahorro energético CPU
    powercfg -setacvalueindex $NewGUID SUB_PROCESSOR IDLEDISABLE 1
    powercfg -setacvalueindex $NewGUID SUB_PROCESSOR PERFENERGYBIAS 0
    powercfg -setacvalueindex $NewGUID SUB_PROCESSOR PERFEPP 0

    # Cooling activo
    powercfg -setacvalueindex $NewGUID SUB_PROCESSOR SYSCOOLPOL 1

    # ===============================
    # PCIe / GPU
    # ===============================

    powercfg -setacvalueindex $NewGUID SUB_PCIEXPRESS ASPM 0

    # ===============================
    # USB
    # ===============================

    powercfg -setacvalueindex $NewGUID SUB_USB USBSELECTIVE 0

    # ===============================
    # DISCO
    # ===============================

    powercfg -setacvalueindex $NewGUID SUB_DISK DISKIDLE 0

    # ===============================
    # RED
    # ===============================

    powercfg -setacvalueindex $NewGUID SUB_NETPOWERSETTING NETWORKADAPTERPOWER 0

    # ===============================
    # SLEEP OFF
    # ===============================

    powercfg -setacvalueindex $NewGUID SUB_SLEEP STANDBYIDLE 0
    powercfg -setacvalueindex $NewGUID SUB_SLEEP HIBERNATEIDLE 0
    powercfg -setacvalueindex $NewGUID SUB_SLEEP HYBRIDSLEEP 0

    # Aplicar
    powercfg -S $NewGUID

    Write-Host ""
    Write-Host "Xploit Optimizer v3 ACTIVADO - CPU desbloqueada." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "Error creando plan." -ForegroundColor Red
}

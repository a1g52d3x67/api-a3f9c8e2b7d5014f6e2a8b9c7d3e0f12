powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -setactive SCHEME_MIN

:: =========================
:: CPU OPTIMIZACIÓN REAL
:: =========================

powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99

:: Turbo agresivo
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2

:: Cooling activo
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1

:: Quitar idle profundo (menos stutter)
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1

:: Energy bias máximo rendimiento
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFENERGYBIAS 0

:: Speed Shift EPP al mínimo (más rendimiento)
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0

:: Core parking OFF (si está disponible)
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100

:: =========================
:: PCIe / GPU
:: =========================

powercfg -setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0

:: =========================
:: USB
:: =========================

powercfg -setacvalueindex SCHEME_CURRENT SUB_USB USBSELECTIVE 0

:: =========================
:: DISCO
:: =========================

powercfg -setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0

:: =========================
:: RED
:: =========================

powercfg -setacvalueindex SCHEME_CURRENT SUB_NETPOWERSETTING NETWORKADAPTERPOWER 0

:: =========================
:: SLEEP OFF
:: =========================

powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0

:: =========================
:: Aplicar
:: =========================

powercfg -setactive SCHEME_CURRENT
powercfg /q SCHEME_CURRENT

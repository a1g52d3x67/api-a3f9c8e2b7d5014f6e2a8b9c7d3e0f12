@echo off
setlocal EnableExtensions

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren privilegios de administrador.
    timeout /t 3 >nul
    exit
)

:: Crear Ultimate Performance (duplicar)
echo Creando plan Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: Activar el plan recién creado (pasa a ser SCHEME_CURRENT)
powercfg -setactive SCHEME_CURRENT >nul 2>&1

:: Cambiar nombre del plan activo
echo Renombrando plan...
powercfg -changename SCHEME_CURRENT "Xploit Optimizer (XPLT v1)" "Plan optimizado para gaming (+FPS , 0-delay)" >nul 2>&1

:: Aplicar configuraciones de rendimiento
echo Aplicando optimizaciones...

:: AC (conectado)
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

:: DC (batería)
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_USB USBSELECTIVE 0

:: Mostrar resultado
echo.
echo ====================================
echo Plan creado y optimizado con exito
echo ====================================
echo.
echo Plan activo:
powercfg -getactivescheme

timeout /t 3 >nul
exit

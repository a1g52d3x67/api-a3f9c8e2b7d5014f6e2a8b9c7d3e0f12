@echo off
setlocal EnableExtensions

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren privilegios de administrador.
    timeout /t 3 >nul
    exit
)

:: Duplicar plan Ultimate Performance
echo Duplicando plan Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: Activar el plan duplicado (el nuevo plan pasa a ser SCHEME_CURRENT)
powercfg -setactive SCHEME_MIN >nul 2>&1

echo Aplicando configuraciones de rendimiento...

:: Configuraciones AC (conectado)
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

:: Configuraciones DC (batería)
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_USB USBSELECTIVE 0

:: Activar y aplicar cambios
powercfg -setactive SCHEME_CURRENT >nul 2>&1

:: Cambiar nombre del plan activo
echo Renombrando plan...
powercfg -changename SCHEME_CURRENT "Xploit Optimizer (XPLT v1)" "Plan de energia de xploit optimizer (+FPS , 0-delay)" >nul 2>&1

:: Mostrar configuración final
echo.
echo ====================================
echo Configuracion aplicada correctamente
echo ====================================
echo.
echo Plan activo actual:
powercfg -getactivescheme
echo.
echo Configuraciones aplicadas:
powercfg /q SCHEME_CURRENT | find "Xploit"

echo.
pause
exit

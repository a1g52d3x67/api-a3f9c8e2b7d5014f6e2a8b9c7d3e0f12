@echo off
setlocal EnableExtensions

:: Verificar que sea administrador
net session >nul 2>&1
if %errorlevel% neq 0 exit

:: Duplicar plan Ultimate Performance
for /f "tokens=3" %%i in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do set XPLT=%%i

:: Si no se pudo duplicar, usar esquema actual
if not defined XPLT (
    for /f "tokens=3" %%i in ('powercfg -getactivescheme') do set XPLT=%%i
)

:: Activar el esquema
powercfg -setactive %XPLT% >nul 2>&1

:: Aplicar configuraciones AC
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR SYSCOOLPOL 1 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR IDLEDISABLE 1 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_USB USBSELECTIVE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_DISK DISKIDLE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_NETPOWERSETTING NETWORKADAPTERPOWER 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_SLEEP STANDBYIDLE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_SLEEP HIBERNATEIDLE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_SLEEP HYBRIDSLEEP 0 >nul 2>&1

:: Aplicar configuraciones DC (bateria)
powercfg -setdcvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg -setdcvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
powercfg -setdcvalueindex %XPLT% SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setdcvalueindex %XPLT% SUB_USB USBSELECTIVE 0 >nul 2>&1

:: Renombrar plan
powercfg -changename %XPLT% "Xploit Optimizer (XPLT v1)" >nul 2>&1

:: Activar plan
powercfg -setactive %XPLT% >nul 2>&1

:: Mensaje final
echo Operacion procesada.
timeout /t 2 >nul
exit

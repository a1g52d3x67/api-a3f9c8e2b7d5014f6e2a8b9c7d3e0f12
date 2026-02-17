@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 exit

:: Crear esquema Ultimate Performance (si no existe)
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: Obtener GUID del esquema recién creado
for /f "tokens=3" %%i in ('powercfg -list ^| findstr /i "Ultimate Performance"') do set XPLT=%%i

:: Si no se encontró, usar el esquema actual
if not defined XPLT (
    for /f "tokens=3" %%i in ('powercfg -getactivescheme') do set XPLT=%%i
)

:: Aplicar configuraciones AC
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PROCESSOR IDLEDISABLE 1 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_USB USBSELECTIVE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_DISK DISKIDLE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_SLEEP STANDBYIDLE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_SLEEP HIBERNATEIDLE 0 >nul 2>&1
powercfg -setacvalueindex %XPLT% SUB_SLEEP HYBRIDSLEEP 0 >nul 2>&1

:: Aplicar también en batería (DC)
powercfg -setdcvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg -setdcvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
powercfg -setdcvalueindex %XPLT% SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setdcvalueindex %XPLT% SUB_USB USBSELECTIVE 0 >nul 2>&1

:: Renombrar
powercfg -changename %XPLT% "Xploit Optimizer (XPLT v1)" >nul 2>&1

:: Activar esquema
powercfg -setactive %XPLT% >nul 2>&1

:: Aplicar cambios
powercfg -S %XPLT% >nul 2>&1

echo Operación procesada.
timeout /t 2 >nul
exit

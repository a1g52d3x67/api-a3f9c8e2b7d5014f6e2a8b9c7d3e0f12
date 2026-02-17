@echo off
setlocal EnableDelayedExpansion
title XPLOIT - MAXIMO RENDIMIENTO SIMPLE

:: Verificar admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Ejecuta como Administrador.
    pause
    exit /b
)

echo Creando Maximo Rendimiento...

:: Crear plan y capturar linea completa
for /f "delims=" %%A in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do (
    set "LINE=%%A"
)

:: El GUID siempre son los ultimos 36 caracteres
set "NEW_GUID=!LINE:~-36!"

echo GUID detectado: %NEW_GUID%
echo.

:: Activar
powercfg -setactive %NEW_GUID%

:: Cambiar nombre
powercfg -changename %NEW_GUID% "Xploit Maximo Rendimiento" "Plan extremo gaming"

:: Aplicar cambios
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR PROCTHROTTLEMAX 99
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR PERFBOOSTMODE 2
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR SYSCOOLPOL 1
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR IDLEDISABLE 1

powercfg -setacvalueindex %NEW_GUID% SUB_PCIEXPRESS ASPM 0
powercfg -setacvalueindex %NEW_GUID% SUB_USB USBSELECTIVE 0
powercfg -setacvalueindex %NEW_GUID% SUB_DISK DISKIDLE 0
powercfg -setacvalueindex %NEW_GUID% SUB_NETPOWERSETTING NETWORKADAPTERPOWER 0

powercfg -setacvalueindex %NEW_GUID% SUB_SLEEP STANDBYIDLE 0
powercfg -setacvalueindex %NEW_GUID% SUB_SLEEP HIBERNATEIDLE 0
powercfg -setacvalueindex %NEW_GUID% SUB_SLEEP HYBRIDSLEEP 0

:: Forzar aplicacion real
powercfg -S %NEW_GUID%

echo.
echo ===============================
echo PLAN ACTIVADO CORRECTAMENTE
echo ===============================
echo.

powercfg -getactivescheme

pause
exit

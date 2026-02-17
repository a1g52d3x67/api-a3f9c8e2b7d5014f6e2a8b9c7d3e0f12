@echo off
setlocal EnableExtensions EnableDelayedExpansion
title XPLOIT - MAXIMO RENDIMIENTO

:: Verificar admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Ejecuta como Administrador.
    pause
    exit /b
)

echo ==========================================
echo    CREANDO MAXIMO RENDIMIENTO REAL
echo ==========================================
echo.

:: 1. Crear Ultimate Performance (Máximo rendimiento)
for /f "tokens=3" %%G in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do (
    set "NEW_GUID=%%G"
)

if not defined NEW_GUID (
    echo ERROR: No se pudo crear el plan.
    powercfg -list
    pause
    exit /b
)

echo GUID creado: %NEW_GUID%
echo.

:: 2. Activarlo
powercfg -setactive %NEW_GUID%

:: 3. Aplicar configuraciones EXACTAS que pediste
echo Aplicando tweaks...

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

:: 4. Reaplicar plan
powercfg -setactive SCHEME_CURRENT

echo.
echo ==========================================
echo   MAXIMO RENDIMIENTO ACTIVADO
echo ==========================================
echo.

powercfg /q SCHEME_CURRENT

pause
exit /b

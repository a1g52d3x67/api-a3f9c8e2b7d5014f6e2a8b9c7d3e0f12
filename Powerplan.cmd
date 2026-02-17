@echo off
setlocal EnableExtensions EnableDelayedExpansion
title XPLOIT - MAXIMO RENDIMIENTO REAL

:: Verificar administrador
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

:: Crear plan Ultimate Performance y capturar GUID
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

:: Activarlo
powercfg -setactive %NEW_GUID%

:: CAMBIAR NOMBRE (AQUI ESTA LO QUE QUERIAS)
powercfg -changename %NEW_GUID% "Xploit Maximo Rendimiento" "Plan extremo optimizado para gaming"

echo Nombre cambiado correctamente.
echo.

echo Aplicando configuraciones...

:: CPU
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR PROCTHROTTLEMAX 99
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR PERFBOOSTMODE 2
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR SYSCOOLPOL 1
powercfg -setacvalueindex %NEW_GUID% SUB_PROCESSOR IDLEDISABLE 1

:: PCIe / USB / Disco
powercfg -setacvalueindex %NEW_GUID% SUB_PCIEXPRESS ASPM 0
powercfg -setacvalueindex %NEW_GUID% SUB_USB USBSELECTIVE 0
powercfg -setacvalueindex %NEW_GUID% SUB_DISK DISKIDLE 0

:: Red
powercfg -setacvalueindex %NEW_GUID% SUB_NETPOWERSETTING NETWORKADAPTERPOWER 0

:: Sleep
powercfg -setacvalueindex %NEW_GUID% SUB_SLEEP STANDBYIDLE 0
powercfg -setacvalueindex %NEW_GUID% SUB_SLEEP HIBERNATEIDLE 0
powercfg -setacvalueindex %NEW_GUID% SUB_SLEEP HYBRIDSLEEP 0

:: APLICAR DEFINITIVAMENTE
powercfg -setactive %NEW_GUID%

echo.
echo ==========================================
echo  XPLOIT MAXIMO RENDIMIENTO APLICADO
echo ==========================================
echo.

echo Plan activo ahora:
powercfg -getactivescheme
echo.

powercfg /q %NEW_GUID%

pause
exit /b

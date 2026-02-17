@echo off
title Xploit Optimizer - Ultimate tweaks
color a
setlocal EnableExtensions EnableDelayedExpansion

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren privilegios de administrador.
    timeout /t 3 >nul
    exit
)

:: Limpiar variable
set "XPLT="

:: Duplicar plan Ultimate Performance y capturar GUID real
for /f "usebackq delims=" %%a in (`powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2^>nul`) do (
    set "linea=%%a"
    set "linea=!linea:*: =!"
    set "XPLT=!linea!"
    goto :found_guid
)

:found_guid
:: Si no se pudo duplicar, obtener esquema activo
if not defined XPLT (
    for /f "tokens=4 delims=: " %%i in ('powercfg -getactivescheme') do (
        set "XPLT=%%i"
    )
)

:: Extraer solo el GUID (formato xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
if defined XPLT (
    for /f "delims=" %%g in ('echo !XPLT! ^| findstr "[0-9a-f][0-9a-f]*-[0-9a-f][0-9a-f]*-[0-9a-f][0-9a-f]*-[0-9a-f][0-9a-f]*-[0-9a-f][0-9a-f]*"') do (
        set "XPLT=%%g"
    )
)

:: Mostrar GUID obtenido para debug
echo GUID obtenido: [%XPLT%]

:: Verificar que el GUID sea válido (formato GUID)
echo %XPLT% | findstr /r "^[0-9a-fA-F]\{8\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{12\}$" >nul
if !errorlevel! neq 0 (
    echo Error: GUID no válido
    timeout /t 5 >nul
    exit
)

:: Solo continuar si XPLT tiene valor válido
if defined XPLT (
    :: Configuraciones AC
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

    :: Configuraciones DC
    powercfg -setdcvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
    powercfg -setdcvalueindex %XPLT% SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
    powercfg -setdcvalueindex %XPLT% SUB_PCIEXPRESS ASPM 0 >nul 2>&1
    powercfg -setdcvalueindex %XPLT% SUB_USB USBSELECTIVE 0 >nul 2>&1

    :: Aplicar los cambios
    powercfg -setactive %XPLT% >nul 2>&1
    
    :: Pequeña pausa para asegurar
    timeout /t 2 /nobreak >nul
    
    :: Renombrar plan (con los parámetros correctos)
    powercfg -changename %XPLT% "Xploit Optimizer (XPLT v1)" "Plan de energía optimizado para máximo rendimiento" >nul 2>&1
    
    :: Verificar si se renombró
    powercfg -query %XPLT% | find "Xploit Optimizer" >nul
    if !errorlevel! equ 0 (
        echo [OK] Plan renombrado exitosamente.
    ) else (
        echo [ERROR] No se pudo renombrar el plan.
        echo Intentando método alternativo...
        powercfg -changename %XPLT% "Xploit Optimizer (XPLT v1)" >nul 2>&1
    )
    
    :: Mostrar plan activo actual
    echo Plan activo actual:
    powercfg -getactivescheme
) else (
    echo No se pudo obtener el GUID del plan.
    timeout /t 3 >nul
    exit
)

echo.
echo Operacion procesada correctamente.
timeout /t 4 >nul
exit

@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren privilegios de administrador.
    timeout /t 3 >nul
    exit
)

:: Duplicar plan Ultimate Performance y capturar GUID real
for /f "tokens=4" %%i in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 ^| find ":"') do (
    set "XPLT=%%i"
    goto :found_guid
)

:found_guid
:: Limpiar el GUID (quitar posibles caracteres extras)
set "XPLT=%XPLT: =%"
set "XPLT=%XPLT:.=%"

:: Si no se pudo duplicar, obtener esquema activo
if not defined XPLT (
    for /f "tokens=4" %%i in ('powercfg -getactivescheme ^| find ":"') do (
        set "XPLT=%%i"
    )
    set "XPLT=%XPLT: =%"
    set "XPLT=%XPLT:.=%"
)

:: Mostrar GUID obtenido para debug
echo GUID obtenido: %XPLT%

:: Solo continuar si XPLT tiene valor
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

    :: Aplicar cambios antes de renombrar
    powercfg -setactive %XPLT% >nul 2>&1
    
    :: Pequeña pausa para asegurar que se apliquen
    timeout /t 1 /nobreak >nul
    
    :: Renombrar plan
    powercfg -changename %XPLT% "Xploit Optimizer (XPLT v1)" "" >nul 2>&1
    
    :: Verificar si se renombró correctamente
    powercfg -query %XPLT% | find "Xploit Optimizer" >nul
    if !errorlevel! equ 0 (
        echo Plan renombrado exitosamente.
    ) else (
        echo Error al renombrar el plan.
    )
) else (
    echo No se pudo obtener el GUID del plan.
    timeout /t 3 >nul
    exit
)

echo Operacion procesada correctamente.
timeout /t 3 >nul
exit

@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren privilegios de administrador.
    timeout /t 3 >nul
    exit
)

:: Guardar el GUID del plan activo actual (por si acaso)
for /f "tokens=4" %%i in ('powercfg -getactivescheme') do set "OLD_PLAN=%%i"

:: Crear Ultimate Performance y capturar su GUID
echo Creando plan Ultimate Performance...
for /f "tokens=4" %%i in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 ^| find ":"') do set "NEW_GUID=%%i"

:: Limpiar el GUID (quitar espacios)
set "NEW_GUID=%NEW_GUID: =%"

:: Mostrar GUID para debug
echo GUID del nuevo plan: %NEW_GUID%

:: Activar el nuevo plan
echo Activando nuevo plan...
powercfg -setactive %NEW_GUID% >nul 2>&1

:: Cambiar nombre del nuevo plan
echo Renombrando plan a "Xploit Optimizer (XPLT v1)"...
powercfg -changename %NEW_GUID% "Xploit Optimizer (XPLT v1)" "Plan optimizado para gaming (+FPS , 0-delay)" >nul 2>&1

:: Aplicar configuraciones al nuevo plan
echo Aplicando optimizaciones...

:: AC (conectado)
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

:: DC (batería)
powercfg -setdcvalueindex %NEW_GUID% SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setdcvalueindex %NEW_GUID% SUB_PROCESSOR PROCTHROTTLEMAX 99
powercfg -setdcvalueindex %NEW_GUID% SUB_PCIEXPRESS ASPM 0
powercfg -setdcvalueindex %NEW_GUID% SUB_USB USBSELECTIVE 0

:: Asegurar que los cambios se apliquen
powercfg -setactive %NEW_GUID% >nul 2>&1

:: Mostrar resultado
echo.
echo ====================================
echo Plan creado y optimizado con exito
echo ====================================
echo.
echo Plan activo AHORA:
powercfg -getactivescheme
echo.
echo Plan anterior:
echo %OLD_PLAN%

timeout /t 5 >nul
exit

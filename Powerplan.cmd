@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren privilegios de administrador.
    timeout /t 3 >nul
    exit /b
)

:: Guardar plan anterior
for /f "tokens=4" %%i in ('powercfg -getactivescheme') do set "OLD_PLAN=%%i"
echo Plan anterior: %OLD_PLAN%

:: Crear Ultimate Performance y capturar el GUID LIMPIO
echo Creando plan Ultimate Performance...
for /f "tokens=4 delims=: " %%i in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 ^| find ":"') do set "NEW_GUID=%%i"

:: Limpiar el GUID (quitar espacios y texto entre paréntesis)
set "NEW_GUID=%NEW_GUID: =%"
for /f "delims=(" %%a in ("%NEW_GUID%") do set "NEW_GUID=%%a"
set "NEW_GUID=%NEW_GUID: =%"

echo GUID capturado: [%NEW_GUID%]

:: Verificar que el GUID sea válido (longitud aproximada de un GUID)
set "guid_length=0"
for /l %%i in (0,1,100) do if "!NEW_GUID:~%%i,1!" neq "" set /a guid_length+=1

if %guid_length% lss 30 (
    echo ERROR: GUID no válido, longitud: %guid_length%
    echo Intentando método alternativo...
    
    :: Método alternativo - obtener el GUID del plan activo después de duplicar
    powercfg -setactive SCHEME_MIN >nul 2>&1
    for /f "tokens=4" %%i in ('powercfg -getactivescheme') do set "NEW_GUID=%%i"
    for /f "delims=(" %%a in ("%NEW_GUID%") do set "NEW_GUID=%%a"
    set "NEW_GUID=%NEW_GUID: =%"
)

echo GUID final: [%NEW_GUID%]

:: Activar el nuevo plan
echo Activando nuevo plan...
powercfg -setactive %NEW_GUID% >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: No se pudo activar el plan
    pause
    exit /b
)

:: Cambiar nombre del nuevo plan (¡AHORA SÍ!)
echo Renombrando plan a "Xploit Optimizer (XPLT v1)"...
powercfg -changename %NEW_GUID% "Xploit Optimizer (XPLT v1)" "Plan optimizado para gaming (+FPS, 0-delay)" >nul 2>&1

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
echo Verificacion - Planes disponibles:
powercfg -list | find "Xploit"

echo.
pause
exit /b

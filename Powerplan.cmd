@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: Verificar administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren privilegios de administrador.
    timeout /t 3 >nul
    exit /b
)

:: Limpiar variables
set "OLD_PLAN="
set "NEW_GUID="

:: Guardar plan anterior (con método más robusto)
for /f "tokens=1-4" %%a in ('powercfg -getactivescheme') do (
    if "%%b"=="de" (
        set "OLD_PLAN=%%c"
    ) else (
        set "OLD_PLAN=%%b"
    )
)
echo Plan anterior: %OLD_PLAN%

:: Crear Ultimate Performance y capturar el GUID como DIOS MANDA
echo Creando plan Ultimate Performance...

:: Ejecutar el comando y guardar la salida en un archivo temporal
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > %temp%\powercfg_temp.txt 2>&1

:: Leer el archivo y buscar el GUID
set "NEW_GUID="
for /f "usebackq tokens=*" %%a in ("%temp%\powercfg_temp.txt") do (
    set "linea=%%a"
    echo !linea! | find "GUID" >nul
    if !errorlevel! equ 0 (
        :: Extraer el GUID usando un bucle de caracteres
        set "linea=!linea:*:=!"
        set "linea=!linea: =!"
        for /f "delims=(" %%b in ("!linea!") do set "NEW_GUID=%%b"
    )
)

:: Si no se encontró, listar todos los planes y coger el último
if not defined NEW_GUID (
    echo No se pudo capturar con método normal, usando lista de planes...
    for /f "skip=3 tokens=1" %%i in ('powercfg -list') do (
        set "NEW_GUID=%%i"
    )
)

:: Limpiar cualquier mierda
set "NEW_GUID=%NEW_GUID: =%"
set "NEW_GUID=%NEW_GUID:(=%"
set "NEW_GUID=%NEW_GUID:)=%"
set "NEW_GUID=%NEW_GUID:GUID=%"
set "NEW_GUID=%NEW_GUID:de=%"
set "NEW_GUID=%NEW_GUID:plan=%"
set "NEW_GUID=%NEW_GUID:energía=%"

echo GUID capturado: [%NEW_GUID%]

:: Verificar que el GUID tenga el formato correcto (con guiones)
echo %NEW_GUID% | find "-" >nul
if %errorlevel% neq 0 (
    echo ERROR: No se pudo obtener el GUID correctamente
    echo.
    echo Contenido del archivo temporal:
    type %temp%\powercfg_temp.txt
    echo.
    echo Planes disponibles:
    powercfg -list
    echo.
    echo Introducelo MANUALMENTE, bro:
    set /p NEW_GUID="GUID: "
)

:: Si sigue sin funcionar, usar un GUID por defecto (el que me mostraste antes)
if not defined NEW_GUID (
    set "NEW_GUID=cc9fd870-3850-427e-bf87-85c000443afc"
    echo Usando GUID por defecto: %NEW_GUID%
)

echo GUID final: [%NEW_GUID%]

:: Activar el nuevo plan
echo Activando nuevo plan...
powercfg -setactive %NEW_GUID%
if %errorlevel% neq 0 (
    echo ERROR: No se pudo activar el plan
    echo.
    echo Introducelo MANUALMENTE otra vez, bro:
    set /p NEW_GUID="GUID: "
    powercfg -setactive %NEW_GUID%
)

:: Cambiar nombre del nuevo plan
echo Renombrando plan a "Xploit Optimizer (XPLT v1)"...
powercfg -changename %NEW_GUID% "Xploit Optimizer (XPLT v1)" "Plan optimizado para gaming (+FPS, 0-delay)"

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

:: Activar el plan para aplicar cambios
powercfg -setactive %NEW_GUID%

:: Mostrar resultado
echo.
echo ====================================
echo Plan creado y optimizado con exito
echo ====================================
echo.
echo Plan activo AHORA:
powercfg -getactivescheme
echo.
echo Verificacion:
powercfg -list | find "Xploit"

:: Limpiar archivo temporal
del %temp%\powercfg_temp.txt 2>nul

echo.
pause
exit /b

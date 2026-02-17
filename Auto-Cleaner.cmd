@echo off
title Xploit Optimizer - Ultimate Tweaks Edition
color 9
chcp 65001 >nul

:: ===== Verificar administrador =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo Ejecuta este archivo como ADMINISTRADOR.
    pause
    exit
)

echo.
echo ===============================
echo     Xploit Optimizer v2
echo ===============================
echo.

:: ===== Limpiar DNS =====
echo Limpiando cache DNS...
ipconfig /flushdns >nul

:: ===== Limpiar TEMP del usuario =====
echo Limpiando archivos temporales del usuario...
for /d %%x in ("%TEMP%\*") do rd /s /q "%%x" 2>nul
del /f /q "%TEMP%\*.*" 2>nul

:: ===== Limpiar TEMP del sistema =====
echo Limpiando temporales del sistema...
for /d %%x in ("%SystemRoot%\Temp\*") do rd /s /q "%%x" 2>nul
del /f /q "%SystemRoot%\Temp\*.*" 2>nul

:: ===== Limpiar cache de miniaturas =====
echo Limpiando cache de miniaturas...
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
start explorer.exe

:: ===== Epic Games =====
echo Limpiando cache de Epic Games...
rd /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved" 2>nul
rd /s /q "%PROGRAMDATA%\Epic\EpicGamesLauncher\DataCache" 2>nul

:: ===== Fortnite =====
echo Limpiando logs de Fortnite...
rd /s /q "%LOCALAPPDATA%\FortniteGame\Saved\Logs" 2>nul
rd /s /q "%LOCALAPPDATA%\FortniteGame\Saved\Crashes" 2>nul

:: ===== Riot / Valorant =====
echo Limpiando logs de Riot / Valorant...
rd /s /q "%LOCALAPPDATA%\VALORANT\Saved\Logs" 2>nul
rd /s /q "%LOCALAPPDATA%\VALORANT\Saved\Crashes" 2>nul
rd /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Cache" 2>nul

:: ===== Vaciar papelera =====
echo Vaciando papelera...
PowerShell -NoProfile -Command "Clear-RecycleBin -Force" >nul 2>&1

echo.
echo Limpieza completada correctamente.
echo.
pause
exit

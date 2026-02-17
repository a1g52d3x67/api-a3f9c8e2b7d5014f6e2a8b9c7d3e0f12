@echo off
setlocal EnableExtensions
title Xploit Optimizer - Ultimate Tweaks Edition
color 9
chcp 65001 >nul

:: ===== Verificar administrador =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    exit
)

echo ===============================
echo        Xploit Optimizer
echo ===============================
echo.

:: ===== Limpiar cache DNS =====
ipconfig /flushdns >nul 2>&1

:: ===== TEMP Usuario =====
for /d %%x in ("%TEMP%\*") do rd /s /q "%%x" 2>nul
del /f /q "%TEMP%\*.*" >nul 2>&1

:: ===== TEMP Sistema =====
for /d %%x in ("%SystemRoot%\Temp\*") do rd /s /q "%%x" 2>nul
del /f /q "%SystemRoot%\Temp\*.*" >nul 2>&1

:: ===== Cache miniaturas =====
taskkill /f /im explorer.exe >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe

:: ===== Epic Games =====
rd /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved" >nul 2>&1
rd /s /q "%PROGRAMDATA%\Epic\EpicGamesLauncher\DataCache" >nul 2>&1

:: ===== Fortnite =====
rd /s /q "%LOCALAPPDATA%\FortniteGame\Saved\Logs" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\FortniteGame\Saved\Crashes" >nul 2>&1

:: ===== Riot / Valorant =====
rd /s /q "%LOCALAPPDATA%\VALORANT\Saved\Logs" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\VALORANT\Saved\Crashes" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Cache" >nul 2>&1

:: ===== Vaciar papelera (estable) =====
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Clear-RecycleBin -Force" >nul 2>&1

:: ===== Final =====
timeout /t 2 >nul
exit

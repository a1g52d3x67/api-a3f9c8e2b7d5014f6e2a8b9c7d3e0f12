@echo off
title Xploit Optimizer - Ultimate Tweaks
chcp 850 >nul
color 9

echo Limpiando cache DNS...
ipconfig /flushdns

echo Borrando archivos temporales del sistema...
del /s /f /q "%TEMP%\*.*"
del /s /f /q "%SystemRoot%\Temp\*.*"
del /s /f /q "%USERPROFILE%\AppData\Local\Temp\*.*"

echo Borrando Prefetch...
del /s /f /q "C:\Windows\Prefetch\*.*"

echo Borrando miniaturas y cache del explorador...
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db"

echo Limpiando basura de Epic Games...
rmdir /s /q "%LOCALAPPDATA%\EpicGamesLauncher\Saved"
rmdir /s /q "%APPDATA%\Epic\*"
rmdir /s /q "%PROGRAMDATA%\Epic\EpicGamesLauncher\DataCache"

echo Limpiando basura de Fortnite...
rmdir /s /q "%LOCALAPPDATA%\FortniteGame\Saved\Logs"
rmdir /s /q "%LOCALAPPDATA%\FortniteGame\Saved\Crashes"
rmdir /s /q "%LOCALAPPDATA%\FortniteGame\Saved\Config\CrashReportClient"

echo Limpiando basura de Riot / Valorant...
rmdir /s /q "%LOCALAPPDATA%\VALORANT\Saved\Logs"
rmdir /s /q "%LOCALAPPDATA%\VALORANT\Saved\Crashes"
rmdir /s /q "%LOCALAPPDATA%\VALORANT\Saved\Config"
rmdir /s /q "%LOCALAPPDATA%\Riot Games\Riot Client\Cache"
rmdir /s /q "%APPDATA%\Riot Games\RiotClientLogs"
rmdir /s /q "%PROGRAMDATA%\Riot Games\Metadata"

echo Limpiando restos de actualizaciones...
del /s /f /q "%SystemRoot%\SoftwareDistribution\Download\*.*"

echo Limpiando informes de errores de Windows...
del /s /f /q "C:\ProgramData\Microsoft\Windows\WER\*.*"
del /s /f /q "%LOCALAPPDATA%\Microsoft\Windows\WER\*.*"

echo Vaciando papelera de reciclaje (si hay algo)...
PowerShell -NoProfile -Command "if ((Get-ChildItem 'C:\$Recycle.Bin' -Recurse -Force | Measure-Object).Count -gt 0) { Clear-RecycleBin -Force }"

echo.
echo LIMPIEZA COMPLETADA - Tu pc mas rapido que la luz con Xlploit Optimizer.
pause
exit

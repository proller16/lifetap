@echo off
title LIFETAP — Iniciando...
color 1F

echo.
echo  ================================================
echo   LIFETAP — Emergency Response App
echo   Instituto Tecnologico de Tijuana
echo  ================================================
echo.
echo  Navegando al proyecto...
cd /d "C:\Users\gnola\.gemini\antigravity\scratch\lifetap"

echo  Iniciando Flutter en Chrome...
echo.
echo  Presiona Ctrl+C para detener el servidor.
echo.

flutter run -d chrome

pause

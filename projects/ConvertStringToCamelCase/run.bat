@echo off
SETLOCAL
set _projectroot=%~dp0

call build

%_projectroot%build\main.exe
if %errorlevel% neq 0 echo ERROR!!!
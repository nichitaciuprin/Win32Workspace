@echo off
SETLOCAL

@REM paths from bat file
set _projectroot=%~dp0

set _deps=%_projectroot%..\..\..\deps
set _build=%_projectroot%build
set _maincpp=%_projectroot%client.cpp

set _mainexe=%_build%\main.exe
set _mainobj=%_build%\main.obj

@REM removes and created build directory
if exist %_build% rmdir /S /Q %_build%
mkdir %_build%

set INCLUDE=^
%_deps%\MSVC\include;^
%_deps%\WindowsKits\10\Include\10.0.22621.0\ucrt;^
%_deps%\WindowsKits\10\Include\10.0.22621.0\um;^
%_deps%\WindowsKits\10\Include\10.0.22621.0\shared
set LIB=^
%_deps%\MSVC\lib\x64;^
%_deps%\WindowsKits\10\Lib\10.0.22621.0\um\x64;^
%_deps%\WindowsKits\10\Lib\10.0.22621.0\ucrt\x64

set _cl=%_deps%\msvc\bin\Hostx64\x64\cl.exe
set _optimimisationDisable=/Od
set _optimimisationLevel2=/O2
set _enableWarningsLevel4=/W4
set _treatWarningsAsErrors=/WX
set _hidelogs=/nologo
set _exceptionHandling=/EHsc
set _enablesExtraWarning=/analyze
set _output=/Fe"%_mainexe%" /Fo"%_mainobj%"
set _options=^
%_exceptionHandling% ^
%_hidelogs% ^
%_optimimisationDisable% ^
%_enableWarningsLevel4% ^
%_enablesExtraWarning% ^
%_output%

%_cl% %_maincpp% %_options%

@REM if build failed, stop
if %errorlevel% neq 0 exit /b %errorlevel%

@REM run
%_mainexe%

if %errorlevel% neq 0 echo ERROR!!!
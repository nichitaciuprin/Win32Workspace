@echo off
SETLOCAL

@REM paths from bat file
set _batdir=%~dp0

set _build=%_batdir%build
set _maincpp=%_batdir%src\main.cpp
set _deps=%_batdir%..\..\deps

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

set _cl=%_deps%\MSVC\bin\Hostx64\x64\cl.exe
set _input=%_maincpp%
set _output=/Fe"%_build%\main" /Fo"%_build%\main"
set _optimimisationDisable=/Od
set _optimimisationLevel2=/O2
set _enableWarningsLevel4=/W4
set _treatWarningsAsErrors=/WX
set _hidelogs=/nologo
set _exceptionHandling=/EHsc
set _enablesExtraWarning=/analyze
set _options=^
%_exceptionHandling% ^
%_hidelogs% ^
%_optimimisationDisable% ^
%_enableWarningsLevel4% ^
%_enablesExtraWarning%
%_cl% %_input% %_output% %_options%

if %errorlevel% neq 0 exit /b %errorlevel%
@echo off
setlocal

set root=%~dp0..\..
set batdir=%~dp0
set build=%batdir%build
set deps=%root%\deps
set exitiferror=if %errorlevel% neq 0 exit /b %errorlevel%

set include=
set include=%include%%deps%\MSVC\include;
set include=%include%%deps%\WindowsKits\10\Include\10.0.22621.0\ucrt;
set include=%include%%deps%\WindowsKits\10\Include\10.0.22621.0\um;
set include=%include%%deps%\WindowsKits\10\Include\10.0.22621.0\shared;
set include=%include%%deps%\BaseOld;
set include=%include%%deps%\Base\include;

set lib=
set lib=%lib%%deps%\MSVC\lib\x64;
set lib=%lib%%deps%\WindowsKits\10\Lib\10.0.22621.0\um\x64;
set lib=%lib%%deps%\WindowsKits\10\Lib\10.0.22621.0\ucrt\x64;

set SYSTEM_LIBS=user32.lib gdi32.lib winmm.lib d3d11.lib d3dcompiler.lib

set _link=%deps%\MSVC\bin\Hostx64\x64\link.exe
set _cl=%deps%\MSVC\bin\Hostx64\x64\cl.exe

set _enableWarningsLevel4=/W4
set _treatWarningsAsErrors=/WX
set _hidelogs=/nologo
set _exceptionHandling=/EHsc
set _enablesExtraWarning=/analyze

@REM /O1 sets a combination of optimizations that generate minimum size code.
@REM /O2 sets a combination of optimizations that optimizes code for maximum speed.
@REM /Ob controls inline function expansion.
@REM /Od disables optimization, to speed compilation and simplify debugging.
@REM /Og (deprecated) enables global optimizations.
@REM /Oi generates intrinsic functions for appropriate function calls.
@REM /Os tells the compiler to favor optimizations for size over optimizations for speed.
@REM /Ot (a default setting) tells the compiler to favor optimizations for speed over optimizations for size.
@REM /Ox is a combination option that selects several of the optimizations with an emphasis on speed. /Ox is a strict subset of the /O2 optimizations.
@REM /Oy suppresses the creation of frame pointers on the call stack for quicker function calls.
set optimisationLevel=/Od

set _options=^
%_exceptionHandling% ^
%_hidelogs% ^
%optimisationLevel% ^
%_enableWarningsLevel4% ^
%_enablesExtraWarning%

if exist %build% rmdir /S /Q %build%
mkdir %build%
@REM if not exist build mkdir build

%_cl%  /nologo /c  %deps%\Base\BitmapWindow.cpp     /Fo:%build%\BitmapWindow  %_options%
%_cl%  /nologo /c  %deps%\Base\SysHelperWin.cpp     /Fo:%build%\SysHelperWin  %_options%
%_cl%  /nologo /c  %deps%\Base\SysHelperWin2.cpp    /Fo:%build%\SysHelperWin2 %_options%
%_cl%  /nologo /c  main.cpp                         /Fo:%build%\main          %_options%

set objfiles=^
%build%\BitmapWindow.obj ^
%build%\SysHelperWin.obj ^
%build%\SysHelperWin2.obj ^
%build%\main.obj

%_link% %objfiles% /out:%build%\main.exe /INCREMENTAL:NO /nologo %SYSTEM_LIBS%

if %errorlevel% neq 0 exit /b %errorlevel%

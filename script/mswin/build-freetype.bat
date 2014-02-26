
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set project=freetype
set config=%defbuildcfg%

:: choose dir
if "%toolset%"=="msvc-10.0" (
	set keydir=vc2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=vc2012
)  else if "%toolset%"=="msvc-12.0" (
	set keydir=vc2013
)  else if "%toolset%"=="msvc-13.0" (
	set keydir=vc2014
)

:: choose lib file name
for /f "tokens=1,2,3 delims=." %%a in ("%libver%") do (
	set libver1=%%a&set libver2=%%b&set libver3=%%c
)

set libfile=freetype%libver1%%libver2%%libver3%

if "%variant%"=="debug" (
	set libfile=%libfile%_D
)

:: build config
set solution=builds\windows\%keydir%\freetype.sln

echo.    solution='%solution%'
echo.    project='%project%' config=%config%
%compiler% /t:%command% /p:Configuration=%config% /nologo /m /clp:ErrorsOnly /fl /flp:logfile=%liblog% %solution%
goto %command%

:build
:rebuild
	:: lib
	echo.  copy lib files:
	copy objs\win32\%keydir%\%libfile%.lib "%outdir-lib%\freetype2.lib"
	
	:: include
	echo.  copy include files:
	xcopy include\* "%outdir-include%\freetype\" /Q /S /Y
	
	goto end

:clean
	goto end

:end
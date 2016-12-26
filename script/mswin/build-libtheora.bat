
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

if "%toolset%"=="msvc-10.0" (
	set keydir=VS2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=VS2012
)  else if "%toolset%"=="msvc-12.0" (
	set keydir=VS2013
)  else if "%toolset%"=="msvc-13.0" (
	set keydir=VS2014
)  else if "%toolset%"=="msvc-14.0" (
	set keydir=VS2015
)

set config=%defbuildcfg%
set libfile=libtheora_static
set project=.\win32\%keydir%\libtheora\libtheora_static.vcxproj

echo.    project='%project%' 
echo.    config=%config%
%compiler% /t:%command% /p:Configuration=%config% /p:UseEnv=true /nologo /m /clp:ErrorsOnly /fl /flp:logfile=%liblog% "%project%"
goto %command%

:build
:rebuild
	:: lib
	echo.  copy lib files:
	copy win32\%keydir%\libtheora\%platform_str%\%configure_str%\%libfile%.lib "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	xcopy include\theora\* "%outdir-include%\theora\" /Q /Y /S
	
	goto end

:clean
	goto end

:end
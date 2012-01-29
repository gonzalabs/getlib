
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set config=%defbuildcfg%
set project=libtheora_static
set libfile=libtheora_static

if "%toolset%"=="msvc-8.0" (
	set keydir=VS2005
) else if "%toolset%"=="msvc-9.0" (
	set keydir=VS2008
) else if "%toolset%"=="msvc-10.0" (
	set keydir=VS2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=VS2012
)

set solution=win32\%keydir%\libtheora_static.sln

echo.    solution='%solution%'
echo.    project='%project%' config=%config%
%compiler% %solution% /%command% %config% /project "%project%" /out %liblog% /useenv 
goto %command%

:build
:rebuild
	:: lib
	echo.  copy lib files:
	copy win32\%keydir%\%platform_str%\%configure_str%\%libfile%.lib "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	xcopy include\theora\* "%outdir-include%\theora\" /Q /Y /S
	
	goto end

:clean
	goto end

:end

if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set project=freetype

if "%toolset%"=="msvc-8.0" (
	set keydir=vc2005
	set config="LIB %configure_str%|%platform_str%"
) else if "%toolset%"=="msvc-9.0" (
	set keydir=vc2008
	set config="LIB %configure_str%|%platform_str%"
) else if "%toolset%"=="msvc-10.0" (
	set keydir=vc2010
	set config="%configure_str%|%platform_str%"
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=vc2012
	set config="%configure_str%|%platform_str%"
)

if "%variant%"=="debug" (
	set libfile=freetype248_D
) else (
	set libfile=freetype248
)

set solution=builds\win32\%keydir%\freetype.sln


echo.    solution='%solution%'
echo.    project='%project%' config=%config%
%compiler% %solution% /%command% %config% /project "%project%" /out %liblog% 
goto %command%

:build
:rebuild
	:: lib
	echo.  copy lib files:
	copy objs\win32\%keydir%\%libfile%.lib "%outdir-lib%\freetype2.lib"
	
	:: include
	echo.  copy include files:
	xcopy include\* "%outdir-include%" /Q /S /Y
	
	goto end

:clean
	goto end

:end
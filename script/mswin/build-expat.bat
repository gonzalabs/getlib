
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set project=expat_static
set config=%defbuildcfg%

if "%toolset%"=="msvc-8.0" (
	set solution=expat-vc80.sln
) else if "%toolset%"=="msvc-9.0" (
	set solution=expat-vc90.sln
) else if "%toolset%"=="msvc-10.0" (
	set solution=expat-vc100.sln
)  else if "%toolset%"=="msvc-11.0" (
	set solution=expat-vc110.sln
)

echo.    solution='%solution%'
echo.    project='%project%' config=%config%
%compiler% %solution% /%command% %config% /project "%project%" /out %liblog% 
goto %command%

:build
:rebuild
	:: bin
	
	:: lib
	echo.  copy lib files:
	copy win32\bin\%variant%\libexpatMD.lib "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	copy lib\expat.h "%outdir-include%\"
	copy lib\expat_external.h "%outdir-include%\"
	
	goto end

:clean
	goto end

:end
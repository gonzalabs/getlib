
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set project=expat_static
set config=%defbuildcfg%
set libfile=libexpatMD

if "%toolset%"=="msvc-10.0" (
	set solution=expat-vc100.sln
)  else if "%toolset%"=="msvc-11.0" (
	set solution=expat-vc110.sln
)  else if "%toolset%"=="msvc-12.0" (
	set solution=expat-vc120.sln
)  else if "%toolset%"=="msvc-13.0" (
	set solution=expat-vc130.sln
)  else if "%toolset%"=="msvc-14.0" (
	set solution=expat.sln
)

echo.    solution='%solution%'
echo.    project='%project%' config=%config%
::%compiler% %solution% /%command% %config% /project "%project%" /out %liblog% 
%compiler% /t:%command% /p:Configuration=%config% /nologo /m /clp:ErrorsOnly /fl /flp:logfile=%liblog% %solution%
goto %command%

:build
:rebuild
	:: bin
	
	:: lib
	echo.  copy lib files:
	copy win32\bin\%variant%\%libfile%.lib "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	copy lib\expat.h "%outdir-include%\"
	copy lib\expat_external.h "%outdir-include%\"
	
	goto end

:clean
	goto end

:end
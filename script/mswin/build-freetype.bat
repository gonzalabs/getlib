
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set project=freetype
set config=%defbuildcfg%

if "%toolset%"=="msvc-10.0" (
	set keydir=vc2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=vc2012
)  else if "%toolset%"=="msvc-12.0" (
	set keydir=vc2014
)

if "%variant%"=="debug" (
	set libfile=freetype2411_D
) else (
	set libfile=freetype2411
)

set solution=builds\win32\%keydir%\freetype.sln


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
	xcopy include\* "%outdir-include%" /Q /S /Y
	
	goto end

:clean
	goto end

:end
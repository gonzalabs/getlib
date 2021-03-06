
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set config=%defbuildcfg%
set projects=LinearMath BulletCollision BulletDynamics

if "%variant%"=="debug" (
	set suffix=_debug
) else (
	set suffix=_release
)

if "%toolset%"=="msvc-10.0" (
	set keydir=vs2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=vs2012
)  else if "%toolset%"=="msvc-12.0" (
	set keydir=vs2013
)  else if "%toolset%"=="msvc-13.0" (
	set keydir=vs2014
)  else if "%toolset%"=="msvc-14.0" (
	set keydir=vs2015
)

for %%p in (%projects%) do (
	echo.    project='%%p' config=%config%
	%compiler% /t:%command% /p:Configuration=%config% /nologo /m /clp:ErrorsOnly /fl /flp:logfile=%liblog% build3\%keydir%\%%p.vcxproj
)
goto %command%

:build
:rebuild
	:: lib
	echo.  copy lib files:
	for %%p in (%projects%) do (
		copy bin\%%p_vs2010_%platform_str%%suffix%.lib "%outdir-lib%\%%p.lib"
	)
	rem copy bin\%%p_%keydir%%suffix%.lib "%outdir-lib%\%%p.lib"
	rem copy build3\%keydir%\%platform_str%\%variant%\%%p.lib "%outdir-lib%\%%p.lib"
	
	:: include
	echo.  copy include files:
	copy src\*.h "%outdir-include%\"
	
	for %%p in (%projects%) do (
		xcopy src\%%p\*.h "%outdir-include%\%%p\" /Q /Y /S /EXCLUDE:%~dp0detail\exclude_impl
	)
	
	goto end

:clean
	goto end

:end
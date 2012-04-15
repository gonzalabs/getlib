
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set config=%defbuildcfg%
set projects=LinearMath BulletCollision BulletDynamics

if "%variant%"=="debug" (
	set suffix=_debug
) else (
	set suffix=
)

if "%toolset%"=="msvc-8.0" (
	set keydir=vs2005
) else if "%toolset%"=="msvc-9.0" (
	set keydir=vs2008
) else if "%toolset%"=="msvc-10.0" (
	set keydir=vs2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=vs2012
)

set solution=msvc\%keydir%\0BulletSolution.sln

echo.    solution='%solution%'

for %%p in (%projects%) do (
	echo.    project='%%p' config=%config%
	%compiler% %solution% /%command% %config% /project "%%p" /out %liblog% 
)
goto %command%

:build
:rebuild
	:: lib
	echo.  copy lib files:
	for %%p in (%projects%) do (
		copy lib\%%p%suffix%.lib "%outdir-lib%\%%p.lib"
	)
	
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
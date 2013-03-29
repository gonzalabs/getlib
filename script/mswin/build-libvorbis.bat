
if %libcfg% NEQ lib (
	echo.  WARNING: no rule to build the library %libname% for the specified target "%libcfg%" - skip
	goto end
)

set config=%defbuildcfg%

if "%toolset%"=="msvc-10.0" (
	set keydir=VS2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=VS2012
)  else if "%toolset%"=="msvc-12.0" (
	set keydir=VS2014
)

set project1=win32\%keydir%\libvorbis\libvorbis_static.vcxproj
set libfile1=libvorbis_static

set project2=win32\%keydir%\libvorbisfile\libvorbisfile_static.vcxproj
set libfile2=libvorbisfile_static

echo.    project='%project1%'
echo.    config=%config%
%compiler% /t:%command% /p:Configuration=%config% /p:UseEnv=true /nologo /m /clp:ErrorsOnly /fl /flp:logfile=%liblog% "%project1%"

echo.    project='%project2%'
echo.    config=%config%
%compiler% /t:%command% /p:Configuration=%config% /p:UseEnv=true /nologo /m /clp:ErrorsOnly /fl /flp:logfile=%liblog% "%project2%"
goto %command%

:build
:rebuild
	:: lib
	echo.  copy lib files:
	copy win32\%keydir%\libvorbis\%platform_str%\%configure_str%\%libfile1%.lib "%outdir-lib%\"
	copy win32\%keydir%\libvorbisfile\%platform_str%\%configure_str%\%libfile2%.lib "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	xcopy include\vorbis\* "%outdir-include%\vorbis\" /Q /Y /S
	
	goto end

:clean
	goto end

:end
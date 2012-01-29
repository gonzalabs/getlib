::
:: MS Windows libraries builder
:: parameters mimic those of boost jam
::
::    %1            - build command
::                    [build, clean]
::                    command "build" actually performs "rebuild"
::
::    variant       - Build variant
::                    [debug,release]
::    toolset       - The c++ compiler to use 
::                    [msvc-8.0,msvc-10.0,etc]
::    address-model - Explicitly request either 32-bit or 64-bit code generation
::                    [32,64]
::    msvc-express  - 
::                    [yes,no]
::    clean-output  - 
::                    [yes,no]
::
::    source        - libraries root directory 
::    output        - build output directory 
::    logout        - build logs output directory
::


:: validating parameters
if "%1"=="" (
	set command=rebuild
) else if "%1"=="rebuild" (
	set command=rebuild
) else if "%1"=="build" (
	set command=rebuild
) else if "%1"=="clean" (
	set command=clean
) else (
	echo unknown build command %1 [use build or clean]
	goto :error
)


:: validating variables
if NOT defined toolset (
	echo ERROR: variable toolset [c++ compiler] is not specified. Use msvc-8.0, msvc-10.0 or alike
	goto :error
)

if /i "%toolset%" EQU "msvc-8.0" ( 
	set comntools="%VS80COMNTOOLS%"
) else if /i "%toolset%" EQU "msvc-9.0" ( 
	set comntools="%VS90COMNTOOLS%"
) else if /i "%toolset%" EQU "msvc-10.0" ( 
	set comntools="%VS100COMNTOOLS%"
) else if /i "%toolset%" EQU "msvc-11.0" ( 
	set comntools="%VS110COMNTOOLS%"
) else (
	echo ERROR: unknown toolset value "%toolset%" is specified
	goto :error
)

pushd %comntools%
	cd ..\..\VC
	set commandprompt="%CD%\vcvarsall.bat"
popd

if /I %comntools%=="%VSINSTALLDIR%\Common7\Tools\" (
	set commandprompt_alreadysetup=yes
) else if /I %comntools%=="%VSINSTALLDIR%Common7\Tools\" (
	set commandprompt_alreadysetup=yes
) else (
	set commandprompt_alreadysetup=no
)

if "%msvc-express%"=="yes" (
	set compiler=VCExpress.exe
) else (
	set compiler=devenv
)

if NOT defined variant (
	set variant=debug
	set configure_str=Debug
	echo WARNING: variable variant is not specified, default value %variant% will be used
) else if "%variant%"=="debug" (
	set configure_str=Debug
) else if "%variant%"=="release" (
	set configure_str=Release
) else (
	echo unknown variant %1 [use debug or release]
	goto :error
)

if NOT defined address-model (
	echo ERROR: variable address-model [target address-model: 32 or 64] is not specified
	goto :error
) else if "%address-model%"=="32" (
	set platform_str=Win32
	set platform_xYY=x32
	set platform_xZZ=x86
) else if "%address-model%"=="64" (
	set platform_str=x64
	set platform_xYY=x64
	set platform_xZZ=x64
) else (
	echo ERROR: unknown address-model value "%address-model%" is specified
	goto :error
)

if NOT defined source (
	echo ERROR: variable source [libraries root dir] is not specified
	goto :error
)

if NOT defined output (
	echo ERROR: variable output [build output dir] is not specified
	goto :error
)

if NOT defined logout (
	set logout=%~dp0\..\..\logs
	echo WARNING: variable logout [log output dir] is not specified, default value %logout% will be used
)


:: convenience variables
set defbuildcfg="%configure_str%|%platform_str%"
set buildlib=%~dp0\detail\build-lib.bat


:: echo configuration
echo.
echo.
echo :::: GETLIB BUILD CONFIG :::::::::::::::::::::::::::::::::::::::::::::::::::
echo .         toolset: %toolset%
echo .   address-model: %address-model%-bit
echo .         variant: %variant%
echo .         command: %command%
echo .
echo .      source dir: %source%
echo .      output dir: %output%
echo ............................................................................

:: prepare environment
	if NOT exist %source% (
		echo ERROR: variable source [libraries root dir] points to a non-existing directory: %source%
		goto :error
	)

	set outdir=%output%\%toolset%\x%address-model%-%variant%
	if exist "%outdir%" (
		if "%clean-output%"=="yes" (
			echo . Clean output demanded, recreating output directory:
			echo .     %outdir%
			rmdir /Q /S %outdir%
			mkdir %outdir%
		)
	) else (
		echo . Creating output directory:
		echo .     %outdir%...
		mkdir %outdir%
	)
	
	set outdir-bin=%outdir%\bin
	if NOT exist "%outdir-bin%" mkdir %outdir-bin%
	set outdir-include=%outdir%\include
	if NOT exist "%outdir-include%" mkdir %outdir-include%
	set outdir-lib=%outdir%\lib
	if NOT exist "%outdir-lib%" mkdir %outdir-lib%
	
	set logdir=%logout%\%toolset%-x%address-model%-%variant%
	if NOT exist "%logdir%" (
		mkdir %logdir% 
	) else (
		del /Q %logdir%\*
	)
	
:: extra configurations
	call "%~dp0\build-all-ext.bat"
	
:: start command prompt
	if %commandprompt_alreadysetup%==yes (
		echo . Required command prompt has been ALREADY SETUP via:
		echo .     %commandprompt%
		echo . If an issue occure start the build procedure over in a clear environment!
	) else (
		echo . Setting up command prompt via:
		echo .     %commandprompt%
		call %commandprompt% %platform_xZZ%
	)
	
:: update paths
	set SAVE_INCLUDE=%INCLUDE%
	set INCLUDE=%outdir-include%;%INCLUDE%
	set SAVE_LIB=%LIB%
	set LIB=%outdir-lib%;%LIB%

:: build libraries
	::call "%buildlib%" CFG library-name library-version [library-directory]
	:: CFG could be [dll, lib or all]
	
	::call "%buildlib%" all bzip2 1.0.6
	call "%buildlib%" lib expat 2.0.1
	call "%buildlib%" lib freetype 2.4.8
	
	call "%buildlib%" all zlib 1.2.5
	call "%buildlib%" lib libpng 1.5.7 lpng157
	call "%buildlib%" lib jpeg 8d
	
	call "%buildlib%" lib libogg 1.3.0
	call "%buildlib%" lib libvorbis 1.3.2
	call "%buildlib%" lib libtheora 1.1.1
	
:: restore paths
	set INCLUDE=%SAVE_INCLUDE%
	set LIB=%SAVE_LIB%
echo ............................................................................
echo.
echo.

goto :end

:error
	echo BUILD WAS TERMINATED!!!
:end

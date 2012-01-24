::
:: MS Windows libraries builder
:: parameters mimic those of boost jam
::
::    %1            - build command [build, clean]
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
if /i "%toolset%" EQU "msvc-9.0" ( 
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
echo .
echo .
echo :::: GETLIB BUILD CONFIG :::::::::::::::::::::::::::::::::::::::::::::::
echo .         toolset: %toolset%
echo .   address-model: %address-model%-bit
echo .         variant: %variant%
echo .         command: %command%
echo .
echo .      source dir: %source%
echo .      output dir: %output%
echo ........................................................................

:: prepare environment
	if NOT exist %source% (
		echo ERROR: variable source [libraries root dir] points to a non-existing directory: %source%
		goto :error
	)

	set target=%output%\%toolset%\x%address-model%-%variant%
	if exist "%target%" (
		if "%clean-output%"=="yes" (
			echo . clean output demanded, recreating target directory:
			echo .     %target%
			rmdir /Q /S %target%
			mkdir %target%
		)
	) else (
		echo . creating target directory:
		echo .     %target%...
		mkdir %target%
	)
	
	set target-bin=%target%\bin
	if NOT exist "%target-bin%" mkdir %target-bin%
	set target-include=%target%\include
	if NOT exist "%target-include%" mkdir %target-include%
	set target-lib=%target%\lib
	if NOT exist "%target-lib%" mkdir %target-lib%
	
	set logdir=%logout%\%toolset%-x%address-model%-%variant%
	if NOT exist "%logdir%" (
		mkdir %logdir% 
	) else (
		del /Q %logdir%\*
	)
	
:: start command prompt
	if %commandprompt_alreadysetup%==yes (
		echo . required command prompt has been ALREADY SETUP via:
		echo .     %commandprompt%
		echo . if an issue occure start the build procedure over in a clear environment!
	) else (
		echo . setting up command prompt via:
		echo .     %commandprompt%
		call %commandprompt% %platform_xZZ%
	)
	
:: update evnironment, allows dependant libraries finding their dependencies (requires a switch /useenv)
	set SAVE_INCLUDE=%INCLUDE%
	set INCLUDE=%target-include%;%INCLUDE%
	set SAVE_LIB=%LIB%
	set LIB=%target-lib%;%LIB%

:: build libraries
	::call "%buildlib%" bzip2 1.0.6
	call "%buildlib%" expat 2.0.1
	call "%buildlib%" freetype 2.4.8
	call "%buildlib%" zlib 1.2.5

:: restore evnironment
	set INCLUDE=%SAVE_INCLUDE%
	set LIB=%SAVE_LIB%
	
echo ........................................................................
echo .
echo .

goto :end

:error
	echo BUILD WAS TERMINATED!!!
:end

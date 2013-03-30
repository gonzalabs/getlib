

:: validating parameters
if "%1"=="" (
	echo ERROR: library config is not specified [dll, lib or all]!
	goto :error
) else (
	set libcfg=%1
)
if "%2"=="" (
	echo ERROR: library name is not specified!
	goto :error
) else (
	set libname=%2
)

if "%3"=="" (
	echo ERROR: library version is not specified!
	goto :error
) else (
	set libver=%3
)

set param4=%4
set param4=%param4:"=%
if "%param4%"=="" (
	set libdir=%libname%-%libver%
) else (
	set libdir=%param4%
)

cd %~dp0..
set script=%cd%\build-%libname%.bat
set liblog=%logdir%\%libname%-%libver%.log

if %libcfg%==all (
	set libcfg-dll=yes
	set libcfg-lib=yes
) else if %libcfg%==dll (
	set libcfg-dll=yes
	set libcfg-lib=no
) else if %libcfg%==lib (
	set libcfg-dll=no
	set libcfg-lib=yes
) else if %libcfg%==off (
	set libcfg-dll=no
	set libcfg-lib=no
	goto :end
) else (
	echo ERROR: unknonw primary library configuration was specified: %libcfg%
	echo.       available options are: dll, lib, all or off
	goto :error
)


echo ............................................................................
echo . LIBRARY %libname%-%libver%
echo ...... at %libdir%

	if NOT exist "%script%" (
		echo.
		echo.  ERROR: library build script not found %script%
		goto :error2
	)
	
	cd "%source%"
	if NOT exist "%libdir%" (
		echo.
		echo.  ERROR: library dir not found at %libdir%
		echo.  current dir is %cd%
		goto :error2
	)

	if %libcfg-dll%==yes (
		echo LIBRARY: %libname%-%libver% BUILD AS: dll>>%liblog%
		date /T >>%liblog%
		echo -------------------------------------------------------------------------------->>%liblog%
		echo.   >>%liblog%
		
		set libcfg=dll
		cd "%source%"
		cd "%libdir%"
		echo.
		echo.  launching library build script, DLL-config...
		call "%script%"
		
		echo.   >>%liblog%
		echo.   >>%liblog%
		echo.   >>%liblog%
		echo.   >>%liblog%
	)
	
	if %libcfg-lib%==yes (
		echo LIBRARY: %libname%-%libver% BUILD AS: lib>>%liblog%
		date /T >>%liblog%
		echo -------------------------------------------------------------------------------->>%liblog%
		echo.   >>%liblog%
		
		set libcfg=lib
		cd "%source%"
		cd "%libdir%"
		echo.
		echo.  launching library build script, LIB-config...
		call "%script%"
		
		echo.   >>%liblog%
		echo.   >>%liblog%
		echo.   >>%liblog%
		echo.   >>%liblog%
	)
	
echo ............................................................................
echo . LIBRARY %libname%-%libver% - BUILD COMPLETE!

goto :end

:error2
	echo . BUILD WAS TERMINATED!!!
	echo .
	echo . LIBRARY %libname%-%libver% - BUILD FAILED!
	goto :end
:error
	echo BUILD WAS TERMINATED!!!
:end

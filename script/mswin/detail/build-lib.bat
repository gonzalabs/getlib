

:: validating parameters
if "%1"=="" (
	echo ERROR: library name is not specified!
	goto :error
) else (
	set libname=%1
)

if "%2"=="" (
	echo ERROR: library version is not specified!
	goto :error
) else (
	set libver=%2
)

if "%3"=="" (
	set libdir=%libname%-%libver%
) else (
	set libdir=%3
)

cd %~dp0..
set script=%cd%\build-%libname%.bat
set libdst=%target%\build-%libname%.bat
set liblog=%logdir%\%libname%-%libver%.log

echo ........................................................................
echo . LIBRARY %libname%-%libver%
echo ...... at %libdir%
echo .

	if NOT exist "%script%" (
		echo . ERROR: library build script not found %script%
		goto :error2
	)
	
	cd "%source%"
	if NOT exist "%libdir%" (
		echo . ERROR: library dir not found at %cd%\%libdir%
		goto :error2
	)
	cd "%libdir%"
	
	echo . launching library build script...
	call "%script%"

echo ........................................................................
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

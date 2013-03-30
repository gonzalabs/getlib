
if %libcfg%==dll (
	set dllfile=fbxsdk-2013.3
	set libfile=fbxsdk-2013.3
) else if %libcfg%==lib (
	set dllfile=
	set libfile=fbxsdk-2013.3-md
) else (
	echo.  WARNING: no rule to build a library "%libname%" for the target "%libcfg%" - skip
	goto end
)

if "%variant%"=="debug" (
	set suffix=d
) else (
	set suffix=
)

set fbxsdk-bin=%libdir%\lib\vs2010\%platform_xZZ%
set fbxsdk-lib=%fbxsdk-bin%
set fbxsdk-include=%libdir%\include

goto %command%

:build
:rebuild
	:: bin
	if %libcfg%==dll (
		echo.  copy bin files:
		copy "%fbxsdk-bin%\%dllfile%%suffix%.dll" "%outdir-bin%\"
		if exist "%fbxsdk-bin%\%dllfile%%suffix%.pdb" (
			copy "%fbxsdk-bin%\%dllfile%%suffix%.pdb" "%outdir-bin%\"
		)
	)
	:: lib
	echo.  copy lib files:
	copy "%fbxsdk-lib%\%libfile%%suffix%.lib" "%outdir-lib%\fbxsdk.lib"
	
	:: include
	echo.  copy include files:
	xcopy "%fbxsdk-include%\*" "%outdir-include%" /Q /S /Y
	goto end

:clean
	echo.  perform clean...
	:: do nothing

:end




if "%variant%"=="debug" (
	set suffix=d
) else (
	set suffix=
)

set fbxsdk-bin=%libdir%\lib\vs2015\%platform_xZZ%\%variant%
set fbxsdk-lib=%fbxsdk-bin%
set fbxsdk-include=%libdir%\include

goto %command%

:build
:rebuild
	:: bin
	echo.  copy bin files:
	copy "%fbxsdk-bin%\*.dll" "%outdir-bin%\"
	copy "%fbxsdk-bin%\*.pdb" "%outdir-bin%\"

	:: lib
	echo.  copy lib files:
	copy "%fbxsdk-lib%\*.lib" "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	xcopy "%fbxsdk-include%\*" "%outdir-include%" /Q /S /Y
	goto end

:clean
	echo.  perform clean...
	:: do nothing

:end


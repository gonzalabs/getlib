
if %libcfg%==lib (
	set target=libjpeg.lib
	set dllfile=
	set libfile=libjpeg
) else (
	echo.  WARNING: no rule to build a library "%libname%" for the target "%libcfg%" - skip
	goto end
)

goto %command%

:build
:rebuild
	if not exist .\Makefile copy makefile.vc Makefile

	echo.  perform clean...
	nmake clean>>"%liblog%" 2>&1
	
	echo.  perform make...
	nmake %target%>>"%liblog%" 2>&1
	
	:: bin
	if %libcfg%==dll copy %dllfile%.dll "%outdir-bin%\"
	
	:: lib
	echo.  copy lib files:
	copy %libfile%.lib "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	copy jconfig.h "%outdir-include%\"
	copy jpeglib.h "%outdir-include%\"
	goto end

:clean
	goto end

:end

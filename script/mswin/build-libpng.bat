
if %libcfg%==lib (
	set target=libpng.lib
	set dllfile=
	set libfile=libpng
) else (
	echo.  WARNING: no rule to build a library "%libname%" for the target "%libcfg%" - skip
	goto end
)

goto %command%

:build
:rebuild
	if not exist .\Makefile copy .\scripts\makefile.vcwin32 Makefile

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
	copy png.h "%outdir-include%\"
	copy pngconf.h "%outdir-include%\"
	copy pnglibconf.h "%outdir-include%\"
	
	goto end

:clean
	echo.  perform clean...
	if exist .\Makefile nmake clean>>"%liblog%" 2>&1

:end

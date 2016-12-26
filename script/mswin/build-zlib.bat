
if %libcfg%==dll (
	set target=zlib1.dll
	set dllfile=zlib1
	set libfile=zdll
) else if %libcfg%==lib (
	set target=zlib.lib
	set dllfile=
	set libfile=zlib
) else (
	echo.  WARNING: no rule to build a library "%libname%" for the target "%libcfg%" - skip
	goto end
)

goto %command%

:build
:rebuild
	if not exist .\Makefile copy .\scripts\makefile.vcwin32 Makefile

	echo.  perform clean...
	nmake -f win32/Makefile.msc clean>>"%liblog%" 2>&1
	
	echo.  perform make...
	if %address-model%==32 (
		nmake -f win32/Makefile.msc LOC="-DASMV -DASMINF" OBJA="inffas32.obj match686.obj" %target%>>"%liblog%" 2>&1
	) else (
		nmake -f win32/Makefile.msc AS=ml64 LOC="-DASMV -DASMINF -I." OBJA="inffasx64.obj gvmat64.obj inffas8664.obj" %target%>>"%liblog%" 2>&1
	)

	
	:: bin
	if %libcfg%==dll copy %dllfile%.dll "%outdir-bin%\"
	
	:: lib
	echo.  copy lib files:
	copy %libfile%.lib "%outdir-lib%\"
	
	:: include
	echo.  copy include files:
	copy zconf.h "%outdir-include%\"
	copy zlib.h "%outdir-include%\"
	goto end

:clean
	echo.  perform clean...
	if exist .\Makefile nmake -f win32/Makefile.msc clean>>"%liblog%" 2>&1

:end


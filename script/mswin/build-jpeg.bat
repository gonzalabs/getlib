
if %libcfg%==lib (
	set target=libjpeg
	set dllfile=
	set libfile=jpeg
) else (
	echo.  WARNING: no rule to build a library "%libname%" for the target "%libcfg%" - skip
	goto end
)

set config=%defbuildcfg%
set project=jpeg
set solution=jpeg.sln

echo.    solution='%solution%'
echo.    project='%project%' config=%config%

if not exist %solution% (
	echo.  MSVC Solution doesn't exist. It will be generate...
	nmake /f makefile.vc setup-v10>>"%liblog%" 2>&1
)
%compiler% /t:%command% /p:Configuration=%defbuildcfg% /nologo /m /clp:ErrorsOnly /fl /flp:logfile=%liblog% %solution%
	
goto %command%

:build
:rebuild
	:: bin
	:: if %libcfg%==dll copy %dllfile%.dll "%outdir-bin%\"
	
	:: lib
	:: file is outputed in %outdir%
	echo.  copy lib files:
	move "%outdir%\%libfile%.lib" "%outdir-lib%\%target%.lib"
	
	:: include
	echo.  copy include files:
	copy jconfig.h "%outdir-include%\"
	copy jpeglib.h "%outdir-include%\"
	copy jmorecfg.h "%outdir-include%\"
	goto end

:clean
	echo.  perform clean...
	if exist .\Makefile nmake clean>>"%liblog%" 2>&1

:end

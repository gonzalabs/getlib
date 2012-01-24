
set project=zlibstat
:: set project=zlibvc <- for dll
set config=%defbuildcfg%

if "%toolset%"=="msvc-8.0" (
	set keydir=vc8
else if "%toolset%"=="msvc-9.0" (
	set keydir=vc9
) else if "%toolset%"=="msvc-10.0" (
	set keydir=vc10
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=vc11
)

set solution=contrib\vstudio\%keydir%\zlibvc.sln

echo . solution='%solution%' project='%project%' config=%config%
%compiler% %solution% /%command% %config% /project "%project%"
goto %command%

:build
:rebuild
	:: bin
	::echo . copy bin files:
	::copy contrib\vstudio\%keydir%\%platform_xZZ%\ZlibDll%variant%\zlibwapi.dll "%target-bin%"
	
	:: lib
	echo . copy lib files:
	::copy contrib\vstudio\%keydir%\%platform_xZZ%\ZlibStat%variant%\zlibwapi.lib "%target-lib%"
	copy contrib\vstudio\%keydir%\%platform_xZZ%\ZlibStat%variant%\zlibstat.lib "%target-lib%"
	
	:: include
	echo . copy include files:
	copy zconf.h "%target-include%"
	copy zlib.h "%target-include%"
	
	goto end

:clean
	goto end

:end

set project=expat_static
set config=%defbuildcfg%

if "%toolset%"=="msvc-8.0" (
	set solution=expat-vc80.sln
) else if "%toolset%"=="msvc-9.0" (
	set solution=expat-vc90.sln
) else if "%toolset%"=="msvc-10.0" (
	set solution=expat-vc100.sln
)  else if "%toolset%"=="msvc-11.0" (
	set solution=expat-vc110.sln
)

echo . solution='%solution%' project='%project%' config=%config%
%compiler% %solution% /%command% %config% /project "%project%"
goto %command%

:build
:rebuild
	:: lib
	echo . copy lib files:
	copy win32\bin\%variant%\libexpatMD.lib "%target-lib%"
	
	:: include
	echo . copy include files:
	copy lib\expat.h "%target-include%"
	copy lib\expat_external.h "%target-include%"
	
	goto end

:clean
	goto end

:end
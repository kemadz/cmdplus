@echo off

:: Clink inject
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if exist "%~dp0clink\clink_x86.exe" (
        %~dp0clink\clink_x86.exe inject -a -q
    )
) else if /i "%PROCESSOR_ARCHITECTURE%"=="amd64" (
    if exist "%~dp0clink\clink_64.exe" (
        %~dp0clink\clink_64.exe inject -a -q
    )
)

:: Change the prompt style
:: Mmm tasty lamb
prompt $E[1;32;40m$P$S{git}$S$_$E[1;37;40m{lamb}$S$E[0m

:: Add aliases
doskey /macrofile="%~dp0aliases"
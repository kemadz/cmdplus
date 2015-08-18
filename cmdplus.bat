@echo off

:: Define root dir
if not defined CMDPLUS_PROFILE (
    set CMDPLUS_PROFILE=%~dp0config
)

:: Change the prompt style
:: Mmm tasty lamb
prompt $E[1;32;40m$P{git}$S$E[1;37;40m{lamb}$S$E[0m

:: Clink inject
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if exist "%~dp0clink\clink_x86.exe" (
        %~dp0clink\clink_x86.exe inject --quiet --profile "%CMDPLUS_PROFILE%"
    )
) else if /i "%PROCESSOR_ARCHITECTURE%"=="amd64" (
    if exist "%~dp0clink\clink_x64.exe" (
        %~dp0clink\clink_x64.exe inject --quiet --profile "%CMDPLUS_PROFILE%"
    )
)

:: Add aliases
doskey /macrofile="%CMDPLUS_PROFILE%\aliases"

:: Set home path
if not defined HOME set HOME=%USERPROFILE%

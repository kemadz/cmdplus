@echo off

:: cmd AutoRun
REG ADD "HKLM\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%~dp0cmdplus.bat" /f

:: cmd Colors
rem REG IMPORT cmd-colors-solarized.reg

:: cmd Font
rem REG IMPORT cmd-font.reg

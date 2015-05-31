@echo off

:: cmd AutoRun
REG ADD "HKLM\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%CD%\cmdplus.bat" /f

:: cmd Colors
REG IMPORT cmd-colors-solarized.reg

:: cmd Font
REG IMPORT cmd-font.reg
@echo off
set "MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.3.4\plugins\maven\lib\maven3"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo Compiling OpenPDF to check for errors...
cd "%~dp0"
call mvn compile -pl openpdf > compile-output.txt 2> compile-errors.txt

echo.
echo Compilation output saved to:
echo   compile-output.txt
echo   compile-errors.txt
echo.

type compile-errors.txt

pause



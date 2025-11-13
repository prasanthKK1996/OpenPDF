@echo off
set "MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.3.4\plugins\maven\lib\maven3"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo Compiling tests...
cd "%~dp0"
call mvn test-compile -pl openpdf > test-compile-output.txt 2> test-compile-errors.txt

echo.
echo Test compilation output saved to:
echo   test-compile-output.txt
echo   test-compile-errors.txt
echo.

type test-compile-errors.txt

pause



@echo off
set "MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.3.4\plugins\maven\lib\maven3"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo Recompiling OpenPDF with BC-FIPS fixes...
cd "%~dp0"
call mvn compile -pl openpdf

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Compilation successful!
    echo.
    echo Now creating JAR...
    cd openpdf\target\classes
    jar -cvf ..\openpdf-1.3.43-fips.jar . > nul 2>&1
    cd ..\..\..
    echo.
    echo FIPS-compliant JAR created at: openpdf\target\openpdf-1.3.43-fips.jar
    dir openpdf\target\openpdf-1.3.43-fips.jar
) else (
    echo.
    echo Compilation failed with error code: %ERRORLEVEL%
)

pause



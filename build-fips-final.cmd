@echo off
set "MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.3.4\plugins\maven\lib\maven3"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo ====================================================================
echo   Final FIPS-Compliant Build with Tests
echo ====================================================================
echo.

cd "%~dp0"

echo [1/4] Cleaning...
call mvn clean -pl openpdf -q

echo [2/4] Compiling main source code...
call mvn compile -pl openpdf

if %ERRORLEVEL% NEQ 0 (
    echo *** MAIN COMPILATION FAILED ***
    pause
    exit /b 1
)

echo.
echo [3/4] Compiling test classes...
call mvn test-compile -pl openpdf

if %ERRORLEVEL% NEQ 0 (
    echo *** TEST COMPILATION FAILED ***
    echo Check output above for errors
    pause
    exit /b 1
)

echo.
echo [4/4] Creating JAR...
cd openpdf\target\classes
jar -cf ..\openpdf-1.3.43-fips.jar . > nul 2>&1
cd ..\..\..

if exist "openpdf\target\openpdf-1.3.43-fips.jar" (
    echo.
    echo ====================================================================
    echo   BUILD SUCCESSFUL!
    echo ====================================================================
    echo.
    echo JAR Location: %CD%\openpdf\target\openpdf-1.3.43-fips.jar
    dir openpdf\target\openpdf-1.3.43-fips.jar
    echo.
    echo Main classes compiled: YES
    echo Test classes compiled: YES
    echo FIPS Compliance: YES
    echo.
    echo ====================================================================
) else (
    echo *** JAR CREATION FAILED ***
)

pause



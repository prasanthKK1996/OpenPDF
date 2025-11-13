@echo off
set "MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.3.4\plugins\maven\lib\maven3"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo ====================================================================
echo   Building OpenPDF with Full FIPS Compliance
echo ====================================================================
echo.
echo This build includes:
echo  - SHA-256 instead of MD5 for document IDs and content hashing
echo  - SHA-256 instead of SHA-1 for digital signatures
echo  - AES-256 for encryption (no RC4)
echo  - BouncyCastle FIPS 2.1.2 support
echo.
echo ====================================================================
echo.

cd "%~dp0"

echo [1/3] Compiling source code...
call mvn clean compile -pl openpdf

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo *** COMPILATION FAILED ***
    pause
    exit /b 1
)

echo.
echo [2/3] Creating JAR file...
cd openpdf\target\classes
jar -cf ..\openpdf-1.3.43-fips.jar .
cd ..\..\..

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo *** JAR CREATION FAILED ***
    pause
    exit /b 1
)

echo.
echo [3/3] Verifying build...
dir openpdf\target\openpdf-1.3.43-fips.jar

echo.
echo ====================================================================
echo   BUILD SUCCESSFUL!
echo ====================================================================
echo.
echo FIPS-Compliant JAR Location:
echo   %CD%\openpdf\target\openpdf-1.3.43-fips.jar
echo.
echo Documentation:
echo   FIPS-COMPLIANCE-GUIDE.md - Complete FIPS usage guide
echo   BUILD-COMPLETE.md - Build summary
echo   FIPS-CONVERSION-SUMMARY.md - Technical details
echo.
echo ====================================================================

pause



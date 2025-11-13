@echo off
set "MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.3.4\plugins\maven\lib\maven3"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo Packaging OpenPDF with BC-FIPS...
cd "%~dp0"
call mvn package -DskipTests -pl openpdf

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! JAR created at: openpdf\target\openpdf-1.3.43-fips.jar
) else (
    echo.
    echo Build failed with error code: %ERRORLEVEL%
)

pause



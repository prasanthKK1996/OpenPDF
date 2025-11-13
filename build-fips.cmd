@echo off
set "MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.3.4\plugins\maven\lib\maven3"
set "PATH=%MAVEN_HOME%\bin;%PATH%"

echo Building OpenPDF with BC-FIPS...
mvn clean package -DskipTests

echo.
echo Build complete! Check openpdf\target for the JAR file.
pause



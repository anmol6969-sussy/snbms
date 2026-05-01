@echo off
echo =======================================================
echo    Starting SNBMS (School Notice Board System)
echo =======================================================
echo.
echo Running embedded Tomcat HTTP server on port 8088...
echo.
echo Once started, open your browser and go to:
echo http://127.0.0.1:8088/
echo.
echo (Press Ctrl+C to stop the server)
echo.
call .\apache-maven-3.9.6\bin\mvn.cmd clean package cargo:run 2>&1


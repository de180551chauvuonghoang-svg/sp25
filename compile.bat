@echo off
echo Compiling Java project...

set CLASSPATH=web\WEB-INF\lib\jakarta.servlet-api-6.0.0.jar;web\WEB-INF\lib\jakarta.mail-1.6.7.jar;web\WEB-INF\lib\sqljdbc4-3.0.jar;web\WEB-INF\lib\gson-2.10.1.jar;web\WEB-INF\lib\jakarta.servlet.jsp.jstl-2.0.0.jar;web\WEB-INF\lib\jakarta.servlet.jsp.jstl-api-2.0.0.jar

echo Classpath: %CLASSPATH%

javac -d build\web\WEB-INF\classes -cp "%CLASSPATH%" src\java\model\*.java src\java\dao\*.java src\java\productDao\*.java src\java\userDao\*.java src\java\orderDao\*.java src\java\service\*.java src\java\controller\*.java src\java\filter\*.java

if %ERRORLEVEL% EQU 0 (
    echo Compilation successful!
    echo Copying web files...
    xcopy /E /Y web\* build\web\
    echo Build complete!
) else (
    echo Compilation failed!
)

pause
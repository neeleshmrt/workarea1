@echo off
set JAVA_HOME=c:\Java\jdk\1.5.0\jre
set TVDXTAT_HOME=C:\Program Files\tvdxtat

"%JAVA_HOME%"\bin\java -Xmx1024m -Dtvdxtat.home="%TVDXTAT_HOME%" -Djava.util.logging.config.file="%TVDXTAT_HOME%\config\logging.properties" -jar "%TVDXTAT_HOME%\lib\tvdxtat.jar" %*

@ECHO off

REM Requires JAVA and saxon jar must be present in root folder with this bat file.
REM This file transforms intermediate *-wellformed.xml file to ARCHive master.xml format
 
ECHO Transforming -wellformed.xml to _master.xml

FOR /D %%g IN ("*") do java -jar saxon9he.jar -s:%~dp0%%g\metadata-working\%%g-wellformed.xml -xsl:dlg-fits-to-master-stylesheet.xsl -o:%~dp0%%g\metadata-working\%%g_master.xml

ECHO Removing unneeded namespaces

FOR /D %%g IN ("*") do fart.exe -i -C --remove %~dp0%%g\metadata-working\%%g_master.xml " xmlns:fits=\"http://hul.harvard.edu/ois/xml/ns/fits/fits_output\" xmlns:aiplevel=\"http://dlg.galileo.usg.edu/aiplevel\""

FOR /D %%g IN ("*") do mkdir %~dp0%%g\metadata

FOR /D %%g IN ("*") do copy %~dp0%%g\metadata-working\%%g_master.xml %~dp0%%g\metadata

SET homedirectory=%~dp0%%g

ECHO %homedirectory%

SET fixpath=%homedirectory:\=\\%

ECHO %fixpath%


FOR /D %%g IN ("*") do fart.exe -i -C %~dp0%%g\metadata\%%g_master.xml "%fixpath%\\objects" "objects"

mkdir trash

FOR /D %%g IN ("*") do move %~dp0%%g\metadata-working %~dp0trash\%%g





pause

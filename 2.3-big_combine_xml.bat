@ECHO off

REM Requires JAVA, FITS, and GREP for Windows (GNU Win 32) and both must be on your system's path. AIP level xml to be split, and saxon jar must be present in root folder with this bat file.
REM This file splits out individual aip level xml fragments from file extracted from spreadsheet, combines FITS output for each digital object, strips redundant xml declarations, and combines the xml into one well formed file.

ECHO Setting xml input that contains AIP level metadata

SET /P xml=Please enter the name of the xml file containing AIP level metadata 

CALL java -jar saxon9he.jar -s:%xml% -xsl:split_TSV_source.xsl -o:trash.xml

FOR /D %%g IN ("*") do move %%g.xml %%g\metadata-working

ECHO Combining FITS xml files into one file per digital object

FOR /D %%g IN ("*") do copy /b %~dp0%%g\metadata-working\*fits.xml %~dp0%%g\metadata-working\%%g-all-fits.xml

ECHO FITS metadata combined per subfolder

ECHO Using GREP to strip redundant xml declarations

FOR /D %%g IN ("*") do grep -E -v "xml version" %~dp0%%g\metadata-working\%%g-all-fits.xml >%~dp0%%g\metadata-working\%%g-all-fits-clean.xml

FOR /D %%g IN ("*") do grep -E -v "xml version" %~dp0%%g\metadata-working\%%g.xml >%~dp0%%g\metadata-working\%%g-clean.xml

FOR /D %%g IN ("*") DO copy /b %~dp0%%g\metadata-working\%%g-clean.xml + %~dp0%%g\metadata-working\%%g-all-fits-clean.xml %~dp0%%g\metadata-working\%%g-working.xml

FOR /D %%g IN ("*") DO copy /b %~dp0open.xml + %~dp0%%g\metadata-working\%%g-working.xml + %~dp0close.xml %~dp0%%g\metadata-working\%%g-wellformed.xml

SET homedirectory=%~dp0%%g

ECHO %homedirectory%

SET fixpath=%homedirectory:\=\\%

ECHO %fixpath%


FOR /D %%g IN ("*") do fart.exe -i -C %~dp0%%g\metadata-working\%%g-wellformed.xml "%fixpath%\\objects" "objects"


Pause

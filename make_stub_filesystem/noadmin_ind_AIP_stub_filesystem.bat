REM @echo off

REM batch file to move individual files into a stub file system for creation of ARCHive SIPs
REM uses ROBOCOPY (included with most Windows distributions) and creates log file copylog.txt in base directory.

FOR %%f in (*) do robocopy %~dp0 %~dp0%%~nf\objects\%%~nf %%f  /XF noadmin_ind_AIP_stub.bat /tee /MOV /v /eta /LOG+:copylog.txt

RMDIR /S /Q noadmin_ind_AIP_stub
RMDIR /S /Q copylog






pause
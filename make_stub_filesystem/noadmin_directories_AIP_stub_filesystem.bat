REM @echo off

REM batch file to move directories containing digital objects into a stub file system for creation of ARCHive SIPs
REM uses ROBOCOPY (included with most Windows distributions) and creates log file copylog.txt in base directory.

FOR /D %%g in (*) do robocopy %%g %%g\objects\%%g /xf *.bat copylog.txt /tee /MOV /eta /LOG+:copylog.txt



pause
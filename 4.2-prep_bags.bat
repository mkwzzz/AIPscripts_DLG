@echo off

REM Requires Python 3.x on path and bagit.py and bag_and_validate_all_folders_python.cmd to be in the same directory as this .bat file 
REM this will .tar and .bzip your bags for upload into archive using 7zprepare_bag.pl
REM requires Perl, 7zip, and Tar for Windows and 7zprepare_bag.pl script must be in the directory with this .bat file

ECHO bagging subfolders...

CALL bag_and_validate_all_folders_python.cmd

ECHO Preparing bags for ARCHive...

timeout /t 2

FOR /D %%g IN ("*_bag") do 7zprepare_bag.pl %%g

DEL *.tar

pause

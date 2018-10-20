@ECHO off
REM This script should be run from the home directory of your FITS installation.
REM It will recurse a series of directories in the parent directory you specify
REM FITS xml will be saved to the directory containing the files. 
REM You can then use the move_fits_xml.bat stylesheet to create the metadata-working folder and move FITS output to it.

SET /P workingdir=Please enter the full path of your working folder where the folders you are turning into AIPs are located 

FOR /R %workingdir% %%g IN ("*") do fits.bat -i %%g -o %%g.fits.xml

PAUSE
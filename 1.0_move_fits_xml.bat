ECHO off

FOR /D %%g IN ("*") do mkdir %~dp0%%g\metadata-working

FOR /D %%g IN ("*") do move %%g\objects\%%g\*.xml %%g\metadata-working

PAUSE
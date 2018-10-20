@ ECHO OFF

ECHO Please close the Explorer window you launched this from 

timeout /t -1



FOR /D %%g IN ("*") DO python bagit.py %%g && python bagit.py --validate %%g && rename "%%g" "%%g_bag"



Pause
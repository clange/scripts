rem This script is assumed to be invoked by cyg-rsnap-c.bat
rem It maps a VSS of d: to y:
rem and then runs rsnapshot daily.
dosdev y: %1
bash.exe -x ./cyg-rsnap.sh
dosdev /d y:

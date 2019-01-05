rem This script is assumed to be invoked
rem using vscsc -exec="cyg-rsnap-c.bat" c:
rem from the path where cyg-rsnap-c.bat is located,
rem e.g. like this:
rem bash -c 'cd path/to/cyg-rsnap; vscsc -exec="cyg-rsnap-c.bat" c:'
rem It maps a VSS of c: to x:
rem and chains into a script that maps a VSS of d: to y:
dosdev x: %1
vscsc -exec="cyg-rsnap-d.bat" d:
dosdev /d x:

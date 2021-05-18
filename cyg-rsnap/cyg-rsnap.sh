#!/bin/bash -x
# /etc/rsnapshot.conf assumes the following drive letters to exist:
# x: (/cygdrive/x): a VSS of c:
# (currently disabled) y: (/cygdrive/y): a VSS of d:
# rsnapshot -V daily
rsnapshot -V sync && \
    rsnapshot -V daily

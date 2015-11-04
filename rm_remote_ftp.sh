#!/bin/bash
# Remove files from remote FTP using lftp client program

FTP_USER=$1
FTP_PW=$2
FTP_SERVER=$3
FTP_DIR=$4
LFTP=/usr/bin/lftp

$LFTP << EOF
open "$FTP_USER":"$FTP_PW"@"$FTP_SERVER"
cd "$FTP_DIR" 
mrm *
bye
EOF
echo "Done."


#!/bin/bash
# Remove files with modification date older than the days specified

PATH=$1
DAYS=$2

find "$PATH" -type f -mtime +"$DAYS" -delete

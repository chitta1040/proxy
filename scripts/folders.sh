#!/bin/sh
# A bash script to create folders with subfolders all in one go.
WORKDIR= "C:\Users\Administrator\Desktop\Panel"
mkdir $WORKDIR && cd $_
mkdir -p {YT}/{cookies,log,driver,main,views}

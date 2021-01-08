#!/bin/bash

# demo-shell.sh: read and execute commands from a file
#                useful for scripted demos
#
# use: ./demo-shell.sh demo-input.txt
#
# note: store your passwords in .demo-secret in the current dir
#
# syntax for the demo-input.txt file
# '#' echo only
# '$' echo first, wait for <RET>, execute command
# ';' don't echo, execute command without wait
# '//' comment
# '' empty lines and anything not matching above cases ignored
#
# Version 1.0
# Fri Jan 8th 2021
# schmidtst@vmware.com

if [ "$1" == "" ]
then
  echo "specify file to read in"
  exit
fi

if [ -f .secrets ]
then
  . .secrets
fi

BOLD="$(tput bold)"
NORM="$(tput sgr0)"

echo $NORM; clear

cat $1 | while read FIRST REMAIN
do
  # echo $FIRST ":" $REMAIN
  if [ "$FIRST" == "#" ]
  then
    echo "#" $REMAIN
  elif [ "$FIRST" == ";" ]
  then
    eval $REMAIN
    if [ $? -ne 0 ]
    then
      exit 1
    fi
  elif [ "$FIRST" == "$" ]
  then
    echo ""
    echo -n "$BOLD\$" $REMAIN $NORM
    read KBINPUT <&2
    eval $REMAIN
    if [ $? -ne 0 ]
    then
      exit 1
    fi
    echo ""
  fi
done

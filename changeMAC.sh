#!/usr/bin/env bash

argv=$#
u=$(id -u)
if [[ u -ne 0 ]]; then
  echo permission denied
else
  if [[ $argv = 2 ]]; then
    ifconfig $1 ether $2
    ifconfig $1 down
    ifconfig $1 up
    echo $1 "has changed it's mac address to "$2
  elif [[ $argv = 1 ]]; then
    mac=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    ifconfig $1 ether $mac
    ifconfig $1 down
    ifconfig $1 up
    echo $1 "has changed it's mac address to "$mac
  else
    echo  "sudo camc <interface> <mac>"
    echo  "imput such like this"
    echo  "cmac en0 aa:bb:cc:dd:ee:ff"
    echo  "or"
    echo  "sudo cmac en0"
  fi
fi

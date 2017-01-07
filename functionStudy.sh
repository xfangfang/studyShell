#!/usr/bin/env bash
b=Bas
if echo "$b" | grep -q "Bash"
then echo "123"
else
  echo 345
fi
curl --help

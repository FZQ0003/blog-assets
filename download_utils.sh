#!/bin/bash

if [ -z "$UTILS_DIR" ]; then
    UTILS_DIR="utils"
fi

mkdir -p "$UTILS_DIR"
_path="$(pwd)"
cd "$UTILS_DIR"

while read line; do
    info=($line)
    echo ${info[2]} ${info[0]} | sha256sum -c 2> /dev/null
    if [ $? != 0 ]; then
        wget ${info[1]} -O ${info[0]}
    fi
    chmod +x ${info[0]}
done < "$_path/utils.txt"

cd "$_path"
echo "Done!"

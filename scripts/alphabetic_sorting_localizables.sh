#!/bin/bash

project_name="BTSPocket"
development_file="./$project_name/en.lproj/Localizable.strings"

alphabetic_sorting() {
    echo "== Sorting localizable files: $1 =="
     sed -i '' '/^$/d' $1 #deletes whitespace lines
  sort $1 -o $1 #sorts file
}

find ./$project_name -name 'Localizable.strings' |
while read file; do
  alphabetic_sorting $file
     echo ""
done


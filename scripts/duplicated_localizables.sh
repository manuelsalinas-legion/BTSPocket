#!/bin/bash 

project_name="BTSPocket"
development_file="./$project_name/en.lproj/Localizable.strings"

es_duplicates=9

sort_and_find_duplicates() {
	echo "== Sorting localizable files: $1 =="
 	sed -i '' '/^$/d' $1 #deletes whitespace lines
  sort $1 -o $1 #sorts file
	duplicates=`sed 's/^[^"]*"\([^"]*\)".*/\1/' $1 | uniq -d`
	if [ ! -z "${duplicates}" ]; then
		echo "error: Found duplicated localizable key"
		echo "error: $duplicates in file: $1"
		exit $es_duplicates
	fi
}

find ./$project_name -name 'Localizable.strings' |
while read file; do
    sort_and_find_duplicates $file
 	echo ""
done

#!/bin/bash

HEADER="
# Summary
* [Introduction](README.md)
"

#set -x

echo "$HEADER" > SUMMARY.md
file_list=$( find . -type f -name "*.md" -not \( -path "./_book/*" \) -depth +1 )


old_chaper=""
for file in $file_list
do
    title=$(awk 'BEGIN {FS=":"} { if($1 == "title") {sub(/[ \t\r\n]+$/, "", $2); print $2; exit}}'  $file)
    if [[ -n "$title" ]]; then
        echo $title
        file=${file:2}
        chapter=${file%%/*}
        echo $chapter
        if [[ ! "$old_chaper" = "$chapter" ]]; then
            [[ ! -f $chapter/README.md ]] && touch $chapter/README.md
            echo "* [$chapter]($chapter/README.md)" >> SUMMARY.md
            old_chaper=$chapter
        fi
        record="    - [${title// /}](${file})" 
        echo "$record" >> SUMMARY.md
    fi
done

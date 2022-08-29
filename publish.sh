#!/bin/bash

function publish() {
        echo "build and publish"
}

modified_files=( $(git diff --name-only HEAD HEAD~1 | grep "$build.gradle") )

for i in "${modified_files=[@]}"
do
        echo "$i"
        newVersion=$(git diff HEAD~1 HEAD "$i" | grep "^+version" | awk '{print $2}')
        oldVersion=$(git diff HEAD~1 HEAD "$i" | grep "^-version" | awk '{print $2}')
        IFS='-' read -ra newVersion <<< "$newVersion"
        newVersion=${newVersion//\'}
        IFS='-' read -ra oldVersion <<< "$oldVersion"
        oldVersion=${oldVersion//\'}

        echo "$newVersion"
        echo "$oldVersion"

        if [ -z "$newVersion" ]
        then
                continue
        else
                publish
        fi
done

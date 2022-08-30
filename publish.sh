#!/bin/bash

function publish() {
        echo build and publish
}

modified_files=( $(git diff --name-only HEAD^ HEAD | grep "$build.gradle") )
echo ${#modified_files[@]}
echo $modified_files

for i in "${modified_files=[@]}"
do
        echo $i
        newVersion=$(git diff HEAD^ HEAD "$i" | grep "^+version" | awk '{print $2}')
        oldVersion=$(git diff HEAD^ HEAD "$i" | grep "^-version" | awk '{print $2}')
        IFS='-' read -ra newVersion <<< "$newVersion"
        newVersion=${newVersion//\'}
        IFS='-' read -ra oldVersion <<< "$oldVersion"
        oldVersion=${oldVersion//\'}

        echo $newVersion
        echo $oldVersion

        if [ -z "$newVersion" ]
        then
                continue
        else
                publish
        fi
done

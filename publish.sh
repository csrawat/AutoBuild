#!/bin/bash

function publish() {
        echo build and publish
        echo "Parameter #1 is $1"
        echo "Parameter #2 is $2"
        echo "Parameter #3 is $3"
        file_name=$1
        suffix="build.gradle"
        pwd
        cd ${file_name%"$file_name"}
        pwd
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
                publish "$i" "$oldVersion" "$newVersion"
        fi
done

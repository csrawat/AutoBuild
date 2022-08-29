#!/bin/bash

function publish() {
        echo "build and publish"
}

echo what is this?

modified_files=( $(git diff-tree --no-commit-id --name-only -r $(git log --format="%H" -n 1) | grep "$build.gradle") )

for i in "${modified_files=[@]}"
do
        echo "$i"
        newVersion=$(git diff $(git log --format="%H" -n 2 | tail -1) HEAD "$i" | grep "^+version" | awk '{print $2}')
        oldVersion=$(git diff $(git log --format="%H" -n 2 | tail -1) HEAD "$i" | grep "^-version" | awk '{print $2}')
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

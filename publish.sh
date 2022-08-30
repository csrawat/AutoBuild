#!/bin/bash

function publish() {
        echo "Parameter #1 is $1"
        echo "Parameter #2 is $2"
        echo "Parameter #3 is $3"

        file_name=$1
        suffix="build.gradle"
        dir=${file_name%"$suffix"}
        cd $dir
        echo build and publish
        cd ../

}

modified_files=( $(git diff --name-only HEAD^ HEAD | grep "$build.gradle") )
echo ${#modified_files[@]}

for each in "${modified_files[@]}"
do
  echo "$each"
  IFS='-'
done

echo start

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
                echo skip-continue
                continue
        else
                echo build and publish
#                 publish "$i" "$oldVersion" "$newVersion"
        fi
        
        echo if-end
done

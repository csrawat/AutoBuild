#!/bin/bash

function publish() {
        echo "Parameter #1 is $1"
        echo "Parameter #2 is $2"
        echo "Parameter #3 is $3"

        file_name=$1
        oldVersion=$2
        newVersion=$3

        IFS='.' read -ra newVersion <<< "$newVersion"
        IFS='.' read -ra oldVersion <<< "$oldVersion"

        flag=false
        for ((i=0; i < ${#newVersion[@]}; i++ ))
        do
          if [ "${newVersion[$i]}" -gt "${newVersion[$i]}" ]
            then
              flag=true
          fi
        done

        if [ $flag = true ]
          then
            suffix="build.gradle"
            dir=${file_name%"$suffix"}
            cd "$dir" || exit
            echo build and publish
            cd ../
          else
            echo cannot publish
        fi
}

modified_files=( $(git diff --name-only HEAD^ HEAD | grep "$build.gradle") )
echo ${#modified_files[@]}

for each in "${modified_files[@]}"
do
        echo "$each"
        newVersion=$(git diff HEAD^ HEAD "$each" | grep "^+version" | awk '{print $2}')
        oldVersion=$(git diff HEAD^ HEAD "$each" | grep "^-version" | awk '{print $2}')
        IFS='-' read -ra newVersion <<< "$newVersion"
        newVersion=${newVersion//\'}
        IFS='-' read -ra oldVersion <<< "$oldVersion"
        oldVersion=${oldVersion//\'}

        echo "$newVersion"
        echo "$oldVersion"

  if [ -z "$newVersion" ]
    then
        echo skip-continue
        continue
    else
        publish "$each" "$oldVersion" "$newVersion"
  fi
done

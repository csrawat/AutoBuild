#!/bin/bash

function publish() {
        echo "Parameter #1 is $1"
        echo "Parameter #2 is $2"
        echo "Parameter #3 is $3"

        FILE_NAME=$1
        OLD_VERSION=$2
        NEW_VERSION=$3
        ROOT_DIR=$(pwd)

        echo "$ROOT_DIR"

        IFS='.' read -ra NEW_VERSION <<< "$NEW_VERSION"
        IFS='.' read -ra OLD_VERSION <<< "$OLD_VERSION"

        flag=false
        if [ -z "$OLD_VERSION" ]
          then
            flag=true
        fi

        for ((i=0; i < ${#OLD_VERSION[@]}; i++ ))
        do

          echo "${NEW_VERSION[$i]}"
          echo "${OLD_VERSION[$i]}"

          if [ "${NEW_VERSION[$i]}" -gt "${OLD_VERSION[$i]}" ]
            then
              flag=true
              break
            else
              continue
          fi
        done

        if [ $flag = true ]
          then
            suffix="build.gradle"
            dir=${FILE_NAME%"$suffix"}
            cd "$dir" || exit
#            execute build command here
            CURR_DIR=$(pwd)
            if [ "$ROOT_DIR" == "$CURR_DIR" ]
              then
                echo cannot publish on root directory
                cd ../
              else
                echo build and publish
            fi
          else
            echo cannot publish
        fi
}

MODIFIED_FILES=( $(git diff --name-only HEAD^ HEAD | grep "$build.gradle") )
echo ${#MODIFIED_FILES[@]}

for each in "${MODIFIED_FILES[@]}"
do
        echo "$each"
        NEW_VERSION=$(git diff HEAD^ HEAD "$each" | grep "^+version" | awk '{print $2}')
        OLD_VERSION=$(git diff HEAD^ HEAD "$each" | grep "^-version" | awk '{print $2}')
        IFS='-' read -ra NEW_VERSION <<< "$NEW_VERSION"
        NEW_VERSION=${NEW_VERSION//\'}
        IFS='-' read -ra OLD_VERSION <<< "$OLD_VERSION"
        OLD_VERSION=${OLD_VERSION//\'}

        echo "$NEW_VERSION"
        echo "$OLD_VERSION"

  if [ -z "$NEW_VERSION" ]
    then
        echo skip-continue
        continue
    else
        publish "$each" "$OLD_VERSION" "$NEW_VERSION"
  fi
done

#!/bin/bash

ROOT_DIR=$(pwd)
VERSION_FILE="$ROOT_DIR/version_file"
touch $VERSION_FILE
printf "new modules are published:" > $VERSION_FILE

function publish() {

        FILE_NAME=$1
        OLD_VERSION=$2
        NEW_VERSION=$3

        flag=false
        if [ -z "$OLD_VERSION" ]
          then
            flag=true
        fi

        if [ ${NEW_VERSION//\./} -gt ${OLD_VERSION//\./} ]
          then
            flag=true
        fi

        suffix="build.gradle"
        dir=${FILE_NAME%"$suffix"}

        if [ $flag = true ]
          then
            cd "$dir" || exit
            CURR_DIR=$(pwd)
            echo "current directory is: [$CURR_DIR]"
            if [ "$ROOT_DIR" == "$CURR_DIR" ]
              then
                echo "cannot publish on root directory"
              else
#                execute build command here
                echo "Publishing new version [$NEW_VERSION] for [$dir]"
                printf "\n$dir\t\t\t$NEW_VERSION" >> $VERSION_FILE
            fi
          else
            echo "[$NEW_VERSION] for [$dir] cannot be published, check if it correctly updated"
        fi

        cd "$ROOT_DIR" || exit
}

MODIFIED_FILES=( $(git diff --name-only HEAD^ HEAD | grep "$build.gradle") )
echo "Total ${#MODIFIED_FILES[@]} build.gradle files are modified"

for each in "${MODIFIED_FILES[@]}"
do
        echo "Checking in [$each] for version upgrade"
        NEW_VERSION=$(git diff HEAD^ HEAD "$each" | grep "^+version" | awk '{print $2}')
        OLD_VERSION=$(git diff HEAD^ HEAD "$each" | grep "^-version" | awk '{print $2}')
        IFS='-' read -ra NEW_VERSION <<< "$NEW_VERSION"
        NEW_VERSION=${NEW_VERSION//\'}
        IFS='-' read -ra OLD_VERSION <<< "$OLD_VERSION"
        OLD_VERSION=${OLD_VERSION//\'}

  if [ -z "$NEW_VERSION" ]
    then
        echo "No change found in the version of [$each]. Will not be published"
        continue
    else
        publish "$each" "$OLD_VERSION" "$NEW_VERSION"
  fi
done

NO_OF_LINES=$(wc -l < $VERSION_FILE)

if [ $NO_OF_LINES -lt 2 ]
        printf "no module is published." > $VERSION_FILE
fi

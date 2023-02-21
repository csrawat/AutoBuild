MODIFIED_FILES=($(git show --format="" --name-only | xargs dirname | sort | uniq))
echo "Total ${#MODIFIED_FILES[@]} files are modified"

for each in "${MODIFIED_FILES[@]}"
do
        echo "Checking in [$each] for version upgrade"
	if [ $each == "." ]
		then
			echo "skipping root level changes"
			continue
	fi
	IFS='/' read -ra FILE_NAME <<< "$each"
	echo $FILE_NAME
done

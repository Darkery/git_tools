#!/bin/bash
set -ex

function get_timestamp() {
    current=`date "+%Y-%m-%d %H:%M:%S"`
    timeStamp=`date -d "$current" +%s`
    currentTimeStamp=$((timeStamp*1000+`date "+%N"`/1000000))
    echo "$currentTimeStamp"
}

function update_submodule() {
    git clone $2
    repo_name=$(echo $2 | awk -F '/' '{print $NF}' |  awk -F '.' '{print $1}')
    submodule_name=$1
    cd $repo_name

    git submodule update --init $submodule_name
    git submodule update --remote $submodule_name
    git add $submodule_name
    timestamp=$(get_timestamp)
    git commit -m "update submodule ${timestamp}"
    git checkout -b "update_submodule_${timestamp}"
    git push origin "update_submodule_${timestamp}"

    cd ..
    rm -rf $repo_name
}

if [ ! -n "$1" ]; then
    echo "Please add the repositories you want to update."
    exit 0
fi

read -p "Are you sure you want to update the submodule of all of these repositories? [y/n]" input
if [[ $input != "y" ]]; then
    echo "Process Stop."
    exit 0
fi

submodule_name=$(echo $@ | awk '{print $1}')
repositories=$(echo $@ | awk '{ $1=""; print $0}')

for repository in $repositories ; do
    update_submodule $submodule_name $repository
done

echo "Finish!"

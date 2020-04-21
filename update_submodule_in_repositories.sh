#!/bin/bash
set -e

function usage {
  >&2 cat << EOF
Usage:
-s             + submodule
-b             + branch name
-r             + repositories urls
EOF
  exit 1;
}

function get_timestamp() {
    current=`date "+%Y-%m-%d %H:%M:%S"`
    timeStamp=`date -d "$current" +%s`
    currentTimeStamp=$((timeStamp*1000+10#$(`date "+%N"`)/1000000))
    echo "$currentTimeStamp"
}

function update_submodule() {
    git clone $3
    repo_name=$(echo $3 | awk -F '/' '{print $NF}' |  awk -F '.' '{print $1}')
    submodule_name=$1
    branch=$2
    cd $repo_name
    git checkout $branch

    git submodule update --init $submodule_name
    git submodule update --remote $submodule_name
    git add $submodule_name
    timestamp=$(get_timestamp)
    git commit -m "update submodule ${branch} ${timestamp}"
    git checkout -b "update_submodule_${branch}_${timestamp}"
    git push origin "update_submodule_${branch}_${timestamp}"
    hub pull-request -m "update_submodule_${branch}_${timestamp}"

    cd ..
    rm -rf $repo_name
}

if [ ! -n "$1" ]; then
    usage
    exit 0
fi

while getopts ":hs:b:r:" opt
do
    case $opt in
        h)
        usage
        ;;
        s)
        submodule_name=$OPTARG
        ;;
        b)
        branch=$OPTARG
        ;;
        r)
        repositories=$OPTARG
        ;;
        ?)
        echo "Unknow Inputs"
        usage
        exit 1;;
    esac
done

read -p "Are you sure you want to update the submodule of all of these repositories? [y/n]" input
if [[ $input != "y" ]]; then
    echo "Process Stop."
    exit 0
fi

for repository in $repositories ; do
    update_submodule $submodule_name $branch $repository
done

echo "Finish!"

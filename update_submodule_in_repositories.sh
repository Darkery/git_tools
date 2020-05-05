#!/bin/bash
set -ex

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
    latter=$(echo $3 | awk -F '//' '{print $NF}')
    set +x
    repo_url="https://${GITHUB_USER}:${GITHUB_PASSWORD}@${latter}"
    git clone $repo_url
    set -x
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
    export FROM_BRANCH="update_submodule_${branch}_${timestamp}"
    git checkout -b $FROM_BRANCH
    git push $repo_url $FROM_BRANCH

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

for repository in $repositories ; do
    update_submodule $submodule_name $branch $repository
done

echo "Finish!"

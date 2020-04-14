#!/bin/bash
set -ex

function usage {
  >&2 cat << EOF
Usage:
-c             + commit_id
-b             + branch names
EOF
  exit 1;
}

function clean_branch() {
    git fetch --all
    git checkout $1
    git reset HEAD .
    git stash
    git stash clear
}

function cherry_pick_commit() {
    branch=$1
    commit_id=$2
    git pull
    git checkout -b "merge_${branch}_${commit_id}"
    git cherry-pick $commit_id
    git push -u origin "merge_${branch}_${commit_id}"
}

if [ ! -n "$1" ]; then
    usage
    exit 0
fi

while getopts ":hc:b:" opt
do
    case $opt in
        h)
        usage
        ;;
        c)
        commit_id=$OPTARG
        ;;
        b)
        branches=$OPTARG
        ;;
        ?)
        echo "Unknow Inputs"
        usage
        exit 1;;
    esac
done

echo "[Alert] This scrip will clean all your uncommitted changes and stash list!"
read -p "Are you sure you've saved all your changes? [y/n]" input
if [[ $input != "y" ]]; then
    echo "Please save your changes first."
    exit 0
fi

#commit_id=$(git rev-parse HEAD)

# other branches
for branch in $branches ; do
    clean_branch $branch
    cherry_pick_commit $branch $commit_id
done

echo "Finish!"

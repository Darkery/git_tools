#!/bin/bash
set -e

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
    echo "Please add the branches you want to merge."
    exit 0
fi

echo "[Alert] This scrip will clean all your uncommitted changes and stash list!"
read -p "Are you sure you've saved all your changes? [y/n]" input
if [[ $input != "y" ]]; then
    echo "Please save your changes first."
    exit 0
fi

# master
clean_branch "master"
commit_id=$(git rev-parse HEAD)
git checkout -b "merge_master_${commit_id}"
git push -u origin "merge_master_${commit_id}"

# other branches
for branch in "$@" ; do
    clean_branch $branch
    cherry_pick_commit $branch $commit_id
done

echo "Finish!"

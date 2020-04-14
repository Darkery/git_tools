# git_tools

## Submit Commits to Multiple Branches 

- Prepare your code and add a commit in `master` branch.
- Make sure your local repo is clean.
- Copy `merge_multiple_branches.sh` to `/` of your git repo.
- `chmod +x merge_multiple_branches.sh`
- Run 
```./merge_multiple_branches.sh $BRANCH_NAME_1 $BRANCH_NAME_2'```

You can add all of branch names that you want to submit.
- Visit your github repo. There're already pushed branches.
All you need to do is create your PRs.

## Update Submodule in Multiple Repositories

- Copy `update_submodule_in_repositories.sh` to an empty directory.
- `chmod +x update_submodule_in_repositories.sh`
- Run ```update_submodule_in_repositories.sh -s $SUMODULE_NAME -b $BRANCH_NAME -r $GIT_URL_1 $GIT_URL_2```
You can add all of git repo urls you want to update their submodules.

Usage:

Option | Parameters
--- | ---
-s | $SUMODULE_NAME
-b | $BRANCH_NAME
-r | $GIT_URLS

```
./update_submodule_in_repositories.sh -s bdh-infra-tools -b master -r git@github.com:Darkery/git_tools.git
```

PS: You can use both `git@github.com:Darkery/git_tools.git` and `https://github.com/Darkery/git_tools.git` as $GIT_URL.
**But SSL type is strongly recommended.**

- Visit your github repo. There's a pushed branch. All you need to do is create your PRs.

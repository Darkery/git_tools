# git_tools

**Request:**

Name | Link 
--- | ---
git |https://git-scm.com/
hub | https://hub.github.com/

## Submit Commits to Multiple Branches 

- Prepare your code with a single commit.
- Make sure your local repo is clean.
- Copy `merge_multiple_branches.sh` to `/` of your git repo.
- `chmod +x merge_multiple_branches.sh`
- Run 
```./merge_multiple_branches.sh -c $COMMIT_ID -b $BRANCH_NAMES'```

Usage:

Option | Parameters
--- | ---
-c | $COMMIT_ID
-b | $BRANCH_NAMES

You can add all of branch names that you want to submit.

**Example:**

```./merge_multiple_branches.sh -c 87fdf3e5a8c9fbd3baf11eca49c1564c183ce2c6 -b "master stable dev"```

- Visit your github repo. Your PRs have been created.

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

**Example:**

```./update_submodule_in_repositories.sh -s bdh-infra-tools -b master -r "git@github.com:Darkery/git_tools.git git@github.com:Darkery/test1.git git@github.com:Darkery/test2.git"```

PS: You can use both `git@github.com:Darkery/git_tools.git` and `https://github.com/Darkery/git_tools.git` as $GIT_URL.
**But SSL type is strongly recommended.**

- Visit your github repo. Your PRs have been created.

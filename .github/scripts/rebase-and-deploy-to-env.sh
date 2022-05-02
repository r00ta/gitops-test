# Env vars parameters: 
# TARGET_BRANCH: dev, stable
# SHA_COMMIT: the sha of the commit to rebase
# AUTHOR: The user
# GITHUB_TOKEN: The token

allowed_branch_values=("dev" "stable")

if ! grep -q "$TARGET_BRANCH" <<< "${allowed_branch_values[@]}"; then
    echo "$TARGET_BRANCH is not a valid choice. Valid choices are dev and stable."
    exit 0
fi

UPSTREAM_REPO_LOCATION=/tmp/upstream
git clone https://$AUTHOR:$GITHUB_TOKEN@github.com/5733d9e2be6485d52ffa08870cabdee0/sandbox.git $UPSTREAM_REPO_LOCATION > /dev/null 2>&1
cd $UPSTREAM_REPO_LOCATION
git checkout -b $TARGET_BRANCH > /dev/null 2>&1

# If the commit is already on TARGET_BRANCH, the feature has been already merged and deployed.
if [ $(git branch --contains $SHA_COMMIT | grep -c $TARGET_BRANCH) -ne 0 ]; then
  echo "$SHA_COMMIT is already on $TARGET_BRANCH branch!"
else
  git rebase $SHA_COMMIT > /dev/null 2>&1
  # git push origin $TARGET_BRANCH &> /dev/null
  echo "$SHA_COMMIT was not on $TARGET_BRANCH branch. $TARGET_BRANCH branch has been rebased and pushed to the upstream repository."
fi

rm -rf $UPSTREAM_REPO_LOCATION

#!/bin/bash -l

set -e

feedstock_name=$1
token=$2
version=$3
hash=$4
fork_owner=$5
email_address=$6
main_branch=$7

# clone the cosmosis feedstock
git clone https://github.com/${fork_owner}/${feedstock_name}-feedstock
cd ${feedstock_name}-feedstock
# make sure we are up-to-date with the origin
git remote add forge https://github.com/conda-forge/${feedstock_name}-feedstock
git config pull.ff only
git config --global user.email "${email_address}"
git config --global user.name "Bot for ${fork_owner}"
git pull forge ${main_branch}

# create new branch
git checkout -b $version

# update version number, build number, hash
sed -i 's/set version = "[0-9\.]*"/set version = "'${version}'"/'  recipe/meta.yaml
sed -i 's/sha256: [0-9a-f]*/sha256: '${hash}'/' recipe/meta.yaml
sed -i 's/number: [0-9]*/number: 0/' recipe/meta.yaml

# commit changes and push to my fork
git commit recipe/meta.yaml -m "Update version to ${version}"

# need to make a new version of the URL including the token
origin_url="https://${token}@github.com/${fork_owner}/${feedstock_name}-feedstock.git"
git push --set-upstream ${origin_url} ${version}

# create a pull request on origin cosmosis feedstock, from my fork
python /make-pr.py ${token} conda-forge/${feedstock_name}-feedstock ${fork_owner} ${version} ${main_branch} "@conda-forge-admin please rerender"

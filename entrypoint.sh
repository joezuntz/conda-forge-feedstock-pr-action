#!/bin/bash -l

set -e

what_to_make=$1
token=$2
version=$3
hash=$4
# new version?

make-cosmosis-feedstock-pr () {
    # clone the cosmosis feedstock
    git clone https://github.com/joezuntz/cosmosis-feedstock
    cd cosmosis-feedstock
    # make sure we are up-to-date with the origin
    git remote add forge https://github.com/conda-forge/cosmosis-feedstock
    git config pull.ff only
    git config --global user.email "joezuntz@googlemail.com"
    git config --global user.name "Bot for Joe Zuntz"
    git pull forge master

    # create new branch
    git checkout -b $version

    # update version number, build number, hash
    sed -i 's/set version = "[0-9\.]*"/set version = "'$version'"/'  recipe/meta.yaml
    sed -i 's/sha256: [0-9a-f]*/sha256: '$hash'/' recipe/meta.yaml
    sed -i 's/number: [0-9]*/number: 0/' recipe/meta.yaml

    # commit changes and push to my fork
    git commit recipe/meta.yaml -m "Update version to $version"

    # need to make a new version of the URL including the token
    origin_url="https://$token@github.com/joezuntz/cosmosis-feedstock.git"
    git push --set-upstream $origin_url $version

    # create a pull request on origin cosmosis feedstock, from my fork
    python /make-pr.py ${token} conda-forge/cosmosis-feedstock joezuntz ${version} "@conda-forge-admin please rerender"
}



if [ "$what_to_make" == "cosmosis" ]
then
    make-cosmosis-feedstock-pr
else
    echo "what-to-make must be cosmosis right now"
    exit 1
fi


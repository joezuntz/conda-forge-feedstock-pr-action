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
    git pull forge master

    # create new branch
    git checkout -b $version

    # update version number, build number, hash
    sed -i tmp 's/set version = "[0-9\.]*"/set version = "'$version'"/'  recipe/meta.yaml
    sed -i tmp 's/sha256: [0-9a-f]*/sha256: '$hash'/' recipe/meta.yaml
    sed -i tmp 's/number: [0-9]*/number: 0/' recipe/meta.yaml

    # commit changes and push to my fork
    git commit recipe/meta.yaml -m "Update version to $version"
    git push origin

    # create a pull request on origin cosmosis feedstock, from my fork
    python /make-pr.py ${token} conda-forge/cosmosis-feedstock joezuntz ${version} "@conda-forge-admin please rerender"
}

make-csl-feedstock-pr () {

    # clone the builder repo
    # update version in script and setup.py
    # commit and push
    # upload with twine

    # clone the builder feedstock
    # create new branch
    # update version number, build number, hash
    # commit changes and push to my fork
    # create a pull request on origin builder feedstock repo

}


if [ "$what_to_make" == "cosmosis" ]
then
    make-cosmosis-feedstock-pr
elif [ "$what_to_make" == "csl" ]
    make-csl-feedstock-pr
else
    echo "what-to-make must be cosmosis or csl"
    exit 1
fi


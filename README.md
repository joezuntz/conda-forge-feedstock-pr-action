# conda-forge-feedstock-pr-action

A Github action to create a pull request on a conda forge feedstock, for example
after uploading to PyPI.

I can only really support this for users from my organizations (DESC and DES), but I'd welcome
PRs from elsewhere.

Instructions below, which assume that you have already:
- created a PyPI project
- created and have a conda-forge feedstock working for your project, including a fork of the feedstock on your account

It assumes that the only change to your feedstock is to update the version number and hash. If you have other changes, e.g. new dependencies, then you can still use this but edit the PR after it runs.


## Create access token

### Github access token

1. Log into github.

2. Click your avatar at the top right on the github main page.

3. Select: Settings > Developer Settings > Personal Access Tokens

4. Click "Generate new token"

5. Write "conda forge token" in the notes.

6. Check the boxes for "repo", "workflow", "notifications", and "write:discussion"

7. Click "Generate Token"

8. Copy the token that appears into a text file for temporary usage.

### PyPI access token

1. Log into pypi.org

2. Click on your user name in the top right > Your Projects > Account Settings

3. Scroll down to "API tokens".  Click "Add API Token"

4. Give the token the same name as your project plus the word "Token"

5. Under "scope", select your project from the drop-down menu

6. Click "Add Token", and again copy the token that appears to your text file.

## Setting up your repository secrets

1. On the repository for your project, click Settings > Secrets > Actions.

2. Click "New Repository Secret". 

3. Use the name "FEEDSTOCK_TOKEN", and copy in the github access token you created above, then "Add Secret"

4. Click on "New Repository Secret" again, and this time use the name PYPI_TOKEN and copy in the PyPI token you generated above.

## Setting up the workflow

1. In your project's repository, make a directories `.github/workflows` if they do not already exist.

2. Create a file `.github/workflows/publish.yml`

3. Copy the contents of `example-workflow.yml` from this repository into your new `publish.yml` file.

4. Update this file to match your project: 
- Change every `mylib` to the name of your project
- Change the line `version=$(head -1  mylib/version.py | cut  -d "'" -f 2)` to however one can determine the version number of your project (this might be looking at git tags, for example)
- Change `your_user_name@your_org.org` to your email address
- Change `your_user_name` to your Github user name, or the name of the github user/org where your fork of the conda-forge feedstock is stored.

## Using your new workflow

- Whenever you create a new release of your project (which you should only do once all your tests pass!), the workflow will run automatically.
- It will upload your new version to PyPI, and create a pull request on your project's conda-forge feedstock, from a branch of your fork of that feedstock.
- Conda forge will run tests automatically on your PR. Once they are complete, you can merge it.


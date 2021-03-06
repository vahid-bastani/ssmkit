#!/bin/bash

set -e # Exit with nonzero exit code if anything fails

# (travis hot fix) only deploy for one build matrix
if [ "$COMPILER" != "clang++-3.7" ]; then
  exit 0
fi

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
cd config/ci/doc/
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in deploy_key.enc -out deploy_key -d
chmod 600 deploy_key
cp deploy_key ~/.ssh/id_rsa
cd ../../..

# turn off interactive host key check
echo -e "Host gitlab.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
# clone gitlab repo 
git clone git@gitlab.com:vahid-bastani/ssmkit.git ../ssmkitgitlab
# backup .git directory
mv ../ssmkitgitlab/.git ../git_backup
# remove all files
rm -rf ../ssmkitgitlab/*
# copy content of this repo to gitlab repo
cp -a . ../ssmkitgitlab
# restore .git directory
rm -rf ../ssmkitgitlab/.git
mv ../git_backup ../ssmkitgitlab/.git

# substitute project number in doxyfile
SHA=`git rev-parse --short HEAD`
sed -e \
  s/master/${TRAVIS_BRANCH}-${SHA}/g \
  Doxyfile > ../ssmkitgitlab/Doxyfile

# copy .gitlab-ci.yml to root of the gitlab repo
cp config/ci/doc/.gitlab-ci.yml ../ssmkitgitlab/.gitlab-ci.yml

cd ../ssmkitgitlab

# push changes to the gitlab repo
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

git add .
git commit -m "Deploy: ${SHA}"
git push

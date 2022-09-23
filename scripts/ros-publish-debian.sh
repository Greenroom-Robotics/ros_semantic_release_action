#!/bin/bash

set -e
set -x

if [ -z "$PUBLISH_SOURCE_FILE" ]
then
  echo "Source file must be defined"
  return 1
fi

if [ -z "$PUBLISH_GIT_SERVER" ]
then
  PUBLISH_GIT_SERVER="github.com"
fi

if [ -z "$PUBLISH_DESTINATION_BRANCH" ]
then
  PUBLISH_DESTINATION_BRANCH=main
fi
OUTPUT_BRANCH="$PUBLISH_DESTINATION_BRANCH"

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$PUBLISH_USER_EMAIL"
git config --global user.name "$PUBLISH_USER_NAME"
git clone --single-branch --branch $PUBLISH_DESTINATION_BRANCH "https://x-access-token:$API_TOKEN_GITHUB@$PUBLISH_GIT_SERVER/$PUBLISH_DESTINATION_REPO.git" "$CLONE_DIR"

if [ ! -z "$PUBLISH_RENAME" ]
then
  echo "Setting new filename: ${PUBLISH_RENAME}"
  DEST_COPY="$CLONE_DIR/$PUBLISH_DESTINATION_FOLDER/$PUBLISH_RENAME"
else
  DEST_COPY="$CLONE_DIR/$PUBLISH_DESTINATION_FOLDER"
fi

echo "Copying contents to git repo"
mkdir -p $CLONE_DIR/$PUBLISH_DESTINATION_FOLDER
if [ -z "$PUBLISH_USE_RSYNC" ]
then
  cp -R ${PUBLISH_SOURCE_FILE} "$DEST_COPY"
else
  echo "rsync mode detected"
  rsync -avrh "$PUBLISH_SOURCE_FILE" "$DEST_COPY"
fi

cd "$CLONE_DIR"

if [ ! -z "$PUBLISH_DESTINATION_BRANCH_CREATE" ]
then
  echo "Creating new branch: ${PUBLISH_DESTINATION_BRANCH_CREATE}"
  git checkout -b "$PUBLISH_DESTINATION_BRANCH_CREATE"
  OUTPUT_BRANCH="$PUBLISH_DESTINATION_BRANCH_CREATE"
fi

if [ -z "$PUBLISH_COMMIT_MESSAGE" ]
then
  PUBLISH_COMMIT_MESSAGE="feat: add debian package: https://$PUBLISH_GIT_SERVER/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}"
fi

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$PUBLISH_COMMIT_MESSAGE"
  echo "Pull and rebase in case another deb has been publishes"
  git pull -r
  echo "Pushing git commit"
  git push -u origin HEAD:"$OUTPUT_BRANCH" --force
else
  echo "No changes detected"
fi
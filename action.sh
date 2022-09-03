#! /bin/sh -l

REMOTE="${1}"

if [ -z "${REMOTE}" ]; then
  echo Please specify an origin
  exit 1
fi

ls -la
git status
git clone --bare "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" . || exit 1
ls -la
git status
git config --global --add safe.directory /github/workspace
ls -la
git status
git remote add --mirror=fetch mirror "${REMOTE}" || exit 1
ls -la
git status
git fetch mirror +refs/heads/*:refs/remotes/origin/* || exit 1
ls -la
git status
git push --force --mirror --prune origin || exit 1
ls -la
git status


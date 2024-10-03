#! /bin/sh -l

REMOTE="${1}"

ORIGIN_BRANCH="${2}"
DESTINATION_BRANCH="${3}" || "${ORIGIN_BRANCH}"

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

if [ -z "${ORIGIN_BRANCH}" ]; then
  ls -la
  git status
  git fetch mirror +refs/heads/*:refs/remotes/origin/* || exit 1
  git fetch mirror ${ORIGIN_BRANCH} ${DESTINATION_BRANCH}

  ls -la
  git status
  git push --force --prune origin ${DESTINATION_BRANCH} || exit 1
  exit 1
fi


ls -la
git status
git fetch mirror +refs/heads/*:refs/remotes/origin/* || exit 1
ls -la
git status
git push --force --mirror --prune origin || exit 1
ls -la
git status


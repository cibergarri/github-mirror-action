#! /bin/sh -l

REMOTE="${1}"

ORIGIN_BRANCH="${2}"
DESTINATION_BRANCH="${3}" || "${ORIGIN_BRANCH}"

echo "REMOTE: ${REMOTE}"
echo "ORIGIN_BRANCH: ${ORIGIN_BRANCH}"
echo "DESTINATION_BRANCH: ${DESTINATION_BRANCH}"
echo "GITHUB: https://${GITHUB_ACTOR}:<pass>@github.com/${GITHUB_REPOSITORY}.git"

if [ -z "${REMOTE}" ]; then
  echo Please specify an origin
  exit 1
fi

if [ -z "${ORIGIN_BRANCH}" ]; then
  git clone --bare "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" . || exit 1
  git config --global --add safe.directory /github/workspace
  git remote add --mirror=fetch mirror "${REMOTE}" || exit 1
  echo "mirroring all branches from ${REMOTE} to ${GITHUB_REPOSITORY}"
  git fetch mirror +refs/heads/*:refs/remotes/origin/* || exit 1
  git push --force --mirror --prune origin || exit 1
  exit 0
fi

git clone "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" . || exit 1
git config --global --add safe.directory /github/workspace
git remote add --mirror=fetch mirror "${REMOTE}" || exit 1

echo "mirroring branch ${ORIGIN_BRANCH} in ${REMOTE} to branch ${DESTINATION_BRANCH} in ${GITHUB_REPOSITORY}"
git fetch mirror ${ORIGIN_BRANCH}:${DESTINATION_BRANCH}
git switch ${DESTINATION_BRANCH} || exit 1
git push --force --set-upstream origin ${DESTINATION_BRANCH} || exit 1
exit 0


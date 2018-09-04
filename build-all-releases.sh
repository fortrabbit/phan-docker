#!/bin/sh
PHAN_REPO="https://github.com/phan/phan.git"
DOCKER_TARGET_TAG="frbit/phan"

echo "Fetching release data from $PHAN_REPO\n"
TAGS=$(git ls-remote --tags $PHAN_REPO | grep -o 'refs/tags/[1-9]*\.[0-9]*\.[0-9]*' | sort | head | grep -o '[^\/]*$')

echo "This will build and push the following phan releases: \n$TAGS"
read -rsp "Press any key to continue or CTRL-C to cancel." -n1 key

LAST_TAG=""
while read -r TAG; do
  LAST_TAG=$TAG
  echo "\nStarting build of $TAG"
  docker build -t $DOCKER_TARGET_TAG:$TAG --build-arg PHAN_RELEASE=$TAG .
  docker push $DOCKER_TARGET_TAG:$TAG
done <<< "$TAGS"

docker tag "$DOCKER_TARGET_TAG:$LAST_TAG" "$DOCKER_TARGET_TAG:latest"
docker push "$DOCKER_TARGET_TAG:latest"

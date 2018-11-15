#!/bin/bash -exo pipefail

for ORB in src/*/; do
  orbname=$(basename $ORB)
  if [[ $(git log -1 --format="" --name-only | grep "$orbname") ]]; then
    (ls ${ORB}orb.yml && echo "orb.yml found, attempting to publish...") || echo "No orb.yml file was found - the next line is expected to fail."
    if [ -z "$CIRCLECI_API_TOKEN" ]; then
      circleci orb publish ${ORB}orb.yml ngs/${orbname}@dev:${CIRCLE_BRANCH}-${CIRCLE_SHA1}
    else
      circleci orb publish ${ORB}orb.yml ngs/${orbname}@dev:${CIRCLE_BRANCH}-${CIRCLE_SHA1} --token $CIRCLECI_API_TOKEN
    fi
  else
    echo "${orbname} not modified; no need to promote"
  fi
  echo "---------------------------"
done

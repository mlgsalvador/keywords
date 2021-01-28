#!/bin/bash
rm -rf artifacts.sh
git ls-tree -r develop --name-only >> artifacts.txt
while read p; do
  export HASH=$(git log -1 --pretty=format:"%h" "$p")
  export AUTHOR=$(git --no-pager show -s --format='%an' ${HASH} | sed 's/ /_/g')
  export TIMESTAMP=$(git log -1 --pretty=format:"%ci" "$p" | sed 's/ /_/g')
  export MESSAGE=$(git log --format=%B -n 1 ${HASH}| sed 's/ /_/g')
  echo "$p" | xargs sed -i -e \
  's?$tag?$tag: 1.0.0?g' -e \
  's?$commitAuthor?'"$AUTHOR"'?g' -e \
  's?$commitDate?'"$TIMESTAMP"'?g' -e \
  's?$commitId?'"$HASH"'?g' -e \
  's?$commitMessage?'"$MESSAGE"'?g'
done <artifacts.txt

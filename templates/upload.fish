#!/usr/local/bin/fish

set pod_version
grep -E 's.version.*=' __ProjectName__.podspec


function ask_pod_version
  read -P "Please set pod version:" -s $pod_version
end

while not string length -q -i '[0-99].[0-99].[0-99]' $pod_version
  set pod_version
  ask_pod_version
end

git stash
git pull --tags
git stash pop

git all .
git commit -am ":bookmark: upgrade: version to $pod_version"
git tag $pod_version

if [ $status -ne 0 ]
  echo "There has existed a same tag: $pod_version\n Please set the pod.version in __ProjectName__.podspec"
  exit 1
end

git push --tags
git push

pod trunk push --verbose







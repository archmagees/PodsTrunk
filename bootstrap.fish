#!/usr/local/bin/fish
set projectName
set githubAccount
set confirm 

set httpsUrl
set sshUrl
set homePageUrl

function ask_user_project_name 
  read -P "Your project name:" -s projectName 
end

function ask_git_hub_account
  read -P "Your GitHub account:" -s githubAccount
end

function confirm_info
  read -P "Confirm?(y/n):" confirm
end
  

function ask_user_necessary_info
  while not string length -q $projectName
    ask_user_project_name
  end
  
  while not string length -q $githubAccount
    ask_git_hub_account
  end

  set homePageUrl   https://github.com/$githubAccount/$projectName
  set sshUrl        git@github.com:$githubAccount/$projectName.git
  set httpsUrl      $homePageUrl.git

end




while not string match -q -i y yes $confirm
  set projectName
  set httpsUrl 
  set sshUrl 
  set homePageUrl
  set githubAccount
  set confirm
  ask_user_necessary_info
  echo "============================================================"
  echo you project name is        :$projectName
  echo Your repo HTTP url is      :$httpsUrl
  echo Your repo ssh url is       :$sshUrl
  echo Your repo home page url is :$homePageUrl
  echo "============================================================"

  confirm_info
end


if [ -d ../$projectName ] 
  echo "Directory ../$projectName exist"
else
  exit 1
end

set targetDirectory ../$projectName


mkdir -p "$targetDirectory/$projectName/$projectName"


set licensePath     $targetDirectory/LICENSE
set gitignorePath   $targetDirectory/.gitignore
set podspecPath     $targetDirectory/$projectName.podspec
set readmePath      $targetDirectory/README.md
set uploadPath      $targetDirectory/upload.fish
set podfilePath     $targetDirectory/Podfile

cp -f templates/LICENSE       $licensePath
cp -f templates/gitignore     $gitignorePath
cp -f templates/pod.podspec   $podspecPath
cp -f templates/README.md     $readmePath
cp -f templates/Podfile       $podfilePath
cp -f templates/upload.fish   $uploadPath

sed -i "" "s|__ProjectName__|$projectName|g"    $gitignorePath
sed -i "" "s|__ProjectName__|$projectName|g"    $licensePath
sed -i "" "s|__archmagees__|$githubAccount|g"   $readmePath

sed -i "" "s|__ProjectName__|$projectName|g"    $uploadPath
sed -i "" "s|__ProjectName__|$projectName|g"    $podfilePath

sed -i "" "s|__ProjectName__|$projectName|g"    $podspecPath
sed -i "" "s|__HomePage__|$homePageUrl|g"       $podspecPath
sed -i "" "s|__HTTPSRepo__|$httpsUrl|g"         $podspecPath

echo "enter $projectName"

cd $targetDirectory

echo "start git init"

git init
git remote add origin $sshUrl

echo "git init finish"

pod install
open $projectName.xcworkspace




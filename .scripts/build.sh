#!/bin/bash

echo 'starting build'
pwd

workingPath="$pwd"

version=""

# Parse command line options
while getopts ":v:" opt; do
  case $opt in
    v)
      version=$OPTARG
      verbose=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND -1))  # Shift off the options and optional --.

# Now you can use the version variable in your script
if [ $version ]; then
  echo "target version: $version"
else
  echo "target version is not set $version"
fi

latestReleaseInRepository() {
    result=$(gh release list --repo $1 --limit 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    if [ -z "${result}" ]; then echo "0.0.0"; else echo $result; fi
}

# Git repositories to use
src_repository="git@github.com:realm/realm-swift.git"
own_repository="git@github.com:Fl0p/realm-swift-xcframework.git"

gh release list --repo https://github.com/realm/realm-swift.git --limit 3




# Get the latest release on Sentry official repository
remoteVersion=$(latestReleaseInRepository $src_repository)
echo "Latest realm version available is ${remoteVersion}"
# Get our latest mirrored release
localVersion=$(latestReleaseInRepository $own_repository)
echo "Latest built xcframework version is ${localVersion}"



if [[ $version || $remoteVersion != $localVersion ]]; then

    targetVersion=$remoteVersion
    if [ $version ]; then
        targetVersion=$version
        echo "Target version is $targetVersion"
    else
        echo "$localVersion is out of date. Updating up to $targetVersion..."
    fi

    gh release download v$targetVersion --repo $src_repository --pattern Carthage.xcframework.zip --clobber

    echo "Unzipping package..."
    unzip -q -o Carthage.xcframework.zip

    ls -la

    git status

else
    echo "Latest version is already built"
fi


exit 0
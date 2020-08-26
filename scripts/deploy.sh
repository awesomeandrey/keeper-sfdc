#!/bin/bash

helpFunction() {
  echo "Usage: $0 -u <target_username> "
  echo "\t-u Target org username"
  exit 1 # Exit script after printing help;
}

while getopts "u:" flag; do
  case $flag in
  u) targetOrgUsername=${OPTARG} ;;
  *) helpFunction ;;
  esac
done

# Print helpFunction in case parameters are empty;
if [ -z $targetOrgUsername ]; then
  echo "Target org username is required!"
  helpFunction
fi

# Begin script in case all parameters are correct;
echo Target org username is: $targetOrgUsername

#Deploy via Metadata API;
tmp_dir=mdapioutput
rm -rf $tmp_dir &&
  sfdx force:org:display -u $targetOrgUsername &&
  sfdx force:source:convert -d $tmp_dir &&
  cp -v destructiveChanges.xml $tmp_dir &&
  sfdx force:mdapi:deploy -d $tmp_dir -u $targetOrgUsername -w 10 --ignorewarnings

# Get exit code of previous command;
status=$?
[ $status -eq 0 ] && echo "Sources are deployed!" || exit 1

# Cleanup directory;
rm -rf $tmp_dir
exit 0

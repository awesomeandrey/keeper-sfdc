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
  echo "Target org username is required"
  helpFunction
fi

# Begin script in case all parameters are correct;
echo Target org username is: $targetOrgUsername

#Deploy via Metadata API;
tmp_dir=mdapioutput
rm -rf $tmp_dir
sfdx force:org:display -u $targetOrgUsername
sfdx force:source:convert -d $tmp_dir
validationCommandResult=$(sfdx force:mdapi:deploy -d $tmp_dir -u $targetOrgUsername -w 100 -c)
echo ${validationCommandResult}
if echo ${validationCommandResult} | grep -iqF failure; then
  echo "Validation failure!"
  exit 1
fi
# Run all tests
runTestsCommandResult=$(sfdx force:apex:test:run -u $targetOrgUsername --wait 10)
echo ${runTestsCommandResult}
if echo ${runTestsCommandResult} | grep -iqF failure; then
  echo "Tests failure!"
  exit 1
fi

rm -rf $tmp_dir
echo "Validated!"

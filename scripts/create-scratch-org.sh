#!/bin/bash

helpFunction() {
    echo "Sample usage: $0 -a <scratch_org_alias> -u <target_dev_hub_username> "
    echo "-a Scratch org alias"
    echo "-u Connected DevHub username"
    exit 1 # Exit script after printing help;
}

while getopts "a:u:" opt; do
    case $opt in
        a) scratchOrgAlias=$OPTARG ;;
        u) devHubUsername=$OPTARG ;;
        ?) helpFunction ;; # Print helpFunction in case parameter is non-existent;
    esac
done

# Print helpFunction in case parameters are empty;
if [ -z $scratchOrgAlias ] || [ -z $devHubUsername ]; then
    echo "Some or all of the parameters are empty."
    helpFunction
fi

# Execute rest of script in case all parameters are correct;
echo Scratch org alias: $scratchOrgAlias
echo DevHub username: $devHubUsername

#Create scratch org;
sfdx force:org:create \
-f config/project-scratch-def.json \
-a $scratchOrgAlias \
-v $devHubUsername &&

#Push source to scratch org;
sfdx force:source:push \
-u $scratchOrgAlias \
-f &&

#Create scratch org test user;
sfdx force:user:create \
-u $scratchOrgAlias \
-f config/dev-user-def.json &&

#Open scratch org;
sfdx force:org:open -u $scratchOrgAlias

echo "You can start coding!"

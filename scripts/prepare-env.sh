#!/bin/bash

helpFunction() {
  echo "Usage: $0 -u <target_username> "
  echo "\t-u Target org username to authorize into"
  exit 1 # Exit script after printing help;
}

while getopts "u:" flag; do
  case "${flag}" in
  u) targetOrgUsername="${OPTARG}" ;;
  *) helpFunction ;;
  esac
done

# Environmental variables
URL=https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz

# Download & install SFDX CLI
openssl aes-256-cbc \
  -K "$encrypted_79a2f6093848_key" \
  -iv "$encrypted_79a2f6093848_iv" \
  -in assets/server.key.enc \
  -out assets/server.key -d
export SFDX_AUTOUPDATE_DISABLE=false
export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
export SFDX_DOMAIN_RETRY=300
export SFDX_DISABLE_APP_HUB=true
export SFDX_LOG_LEVEL=DEBUG
mkdir sfdx
wget -qO- $URL | tar xJ -C sfdx --strip-components 1
"./sfdx/install"
export PATH=./sfdx/$(pwd):$PATH
sfdx --version
sfdx plugins --core

# Authorize into DevHub org
sfdx force:auth:jwt:grant \
  --clientid $KEEPER_CONSUMERKEY \
  --jwtkeyfile assets/server.key \
  --username $KEEPER_USERNAME \
  --setdefaultdevhubusername -a $targetOrgUsername

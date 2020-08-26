## Keeper

<img src="https://github.com/awesomeandrey/keeper/blob/master/public/logo.png" alt="Keeper logo" width="50" height="50"/>

Salesforce application supporting encryption for user-defined credentials :closed_lock_with_key:

#### Technical stack

`salesforce` `sfdx` `travis-ci`

#### Resources used

- [Salesforce CRM](https://www.salesforce.com)
- [Salesforce Lightning Design System](https://www.lightningdesignsystem.com)
- [SFDX CLI](https://developer.salesforce.com/tools/sfdxcli)
- [Travis CI](https://travis-ci.org)
- [Continuous Integration Using Salesforce DX & Travis CI](https://trailhead.salesforce.com/content/learn/modules/sfdx_travis_ci)
- [Apex Cipher](https://medium.com/@krissparks/apex-aes256-bit-encryption-f3434080eea7)

#### Common commands

Terminal commands below should be run from root folder context.

| Command | Description |
| ----- | ----- |
| `sfdx force:org:list` | List all available orgs (DevHub org & scratch orgs) |
| `sh scripts/create-scratch-org.sh -a <SCRATCH ORG AlIAS> -u <DEV HUB ORG ALIAS>` | Spin up scratch org & push sources there |
| `sfdx force:source:pull -u <TARGET SCRATCH ORG ALIAS>` | Pull modified sources from scratch org |
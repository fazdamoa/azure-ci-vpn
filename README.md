# azure-ci-vpn
A DIY 'VPN' solution where you pay only for what you use in your own infrastructure.

## What this solution does

This is just a bash script to spin up a Container Instance in Azure, set up a SOCKS proxy to it, then spin it down.

You can then use FoxyProxy in Firefox to connect to the SOCKS instance on port 3128 and voila! You are now surfing the web from your Azure container with a temporary Azure IP. I used this to get around a block Virgin Media has on LibGen.

## Prerequisites

- A small knowledge of WSL/Linux/Bash
- A Linux terminal
- Azure CLI installed
- An Azure account with access to create a service principal
- A resource group and a service principal with contributor rights
- SSH key installed on the client machine

## Getting Started

### Set up the credentials file
Create a service principal over your Resource Group

`az ad sp create-for-rbac -n ftbvpn --role contributor --scopes /subscriptions/XXXX-XXXX-XXXXX/resourceGroups/ftbvpn`

Take the output of this command and save into a file called `creds.txt` along with your SSH public key like this:

```
# Creds.txt file in local directory
spuser=XXXXXXXXXXXXXXXXXXXXXXXXXXX
sppassword=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
sptenant=XXXXXXXXXXXXXXXXXXXXXXXXXX
pubkey='ssh-rsa AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ftb@ftbpc'
```

### Set up and execute script
Modify the `start-vpn.sh` script for desired location in Azure. Default is UK South

Once done, execute the script in bash 

`bash ./start-vpn.sh`

You will now have a proxy to your container! Try and open a SOCKS5 proxy to the localhost:3128 in Foxyproxy.

Once you exit the SSH session with Ctrl + C, the script will take the container down.

## Why use this?

- Cheap. If you only need to connect through a 'VPN' for minutes or an hour infrequently, this solution literally costs you cents per month if you aren't already on free tier.
- Anonymous. You own the container in Azure, and it dies once you are done. There are no logs.
- Fun. Learn a bit of Azure!

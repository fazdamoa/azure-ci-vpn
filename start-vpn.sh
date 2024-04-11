#!/bin/bash
set -e
# Vars
rg=""
pubkey=""
location="uksouth"
spusername=""
sppassword=""
sptenant=""

# Login to Azure

echo "Logging in to Azure..."
echo ""

source ./creds.txt
az login --service-principal --username $spusername --password $sppassword --tenant $sptenant

echo "Creating SSH Container..."
echo ""

# create random guid
url_guid=$(uuidgen)

az container create --resource-group $rg \
    --name $rg \
    --image fazdamoa/ftbvpn:v1 \
    --ports 2222 \
    --dns-name-label $url_guid \
    --memory 0.5 \
    --environment-variables 'name'='openssh-server' 'hostname'='openssh-server' 'USER_NAME'='sshuser' 'SUDO_ACCESS'='true' PUBLIC_KEY="$pubkey"

echo "Waiting for container to accept connections..."
sleep 45

echo "You are now SSHing to the container."
echo "Press ctrl + c ONCE to exit and delete"

ssh -D 3128 -oStrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q -C -p 2222 -N  sshuser@${url_guid}.${location}.azurecontainer.io

wait $!

echo "Deleting container..."
az container delete --name $rg --resource-group $rg --yes

echo "Checking for any containers..."
az container list -g $rg
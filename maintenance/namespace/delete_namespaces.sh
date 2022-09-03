#!/bin/bash

# To create .dev and describe AWS_ACCOUNT_ID, NAMESPACES.
SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/.env

IFS=$'\n'
echo "============ Namespaces ============"
echo "${NAMESPACES[@]}"
echo "===================================="

while true; do
    read -p "Do you wish to delete the namespaces? (y/n): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done

for namespace in "${NAMESPACES[@]}" ; do
  aws quicksight delete-namespace \
            --aws-account-id $AWS_ACCOUNT_ID \
            --namespace "${namespace}" | jq .
done
#!/bin/bash

# To create .env and describe AWS_ACCOUNT_ID, USER_ARNS, DATASET_IDS.
SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/.env

IFS=$'\n'
echo "========================================== Users =============================================="
echo "${USER_ARNS[@]}"
echo "========================================== Datasets ==========================================="
echo "${DATASET_IDS[@]}"
echo "==============================================================================================="

while true; do
    read -p "Do you wish to revoke author permissions to the users for the datasets? (y/n): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo 'Please input your profile.'
echo -n 'PROFILE: '
read profile

if [ $profile = 'ngydv' ]; then
  for user_arn in "${USER_ARNS[@]}" do
    for data_set_id in "${DATASET_IDS[@]}" do
      aws quicksight update-data-set-permissions \
                --aws-account-id $AWS_ACCOUNT_ID \
                --data-set-id "${data_set_id}" \
                --revoke-permissions Principal=${user_arn},Actions=quicksight:DescribeDataSet,quicksight:DescribeDataSetPermissions,quicksight:PassDataSet,quicksight:DescribeIngestion,quicksight:ListIngestions,quicksight:UpdateDataSet,quicksight:DeleteDataSet,quicksight:CreateIngestion,quicksight:CancelIngestion,quicksight:UpdateDataSetPermissions | jq .
    done
  done
else
  for user_arn in "${USER_ARNS[@]}" do
    for data_set_id in "${DATASET_IDS[@]}" do
      aws quicksight update-data-set-permissions \
                --aws-account-id $AWS_ACCOUNT_ID \
                --profile $profile \
                --data-set-id "${data_set_id}" \
                --revoke-permissions Principal=${user_arn},Actions=quicksight:DescribeDataSet,quicksight:DescribeDataSetPermissions,quicksight:PassDataSet,quicksight:DescribeIngestion,quicksight:ListIngestions,quicksight:UpdateDataSet,quicksight:DeleteDataSet,quicksight:CreateIngestion,quicksight:CancelIngestion,quicksight:UpdateDataSetPermissions | jq .
    done
  done
fi

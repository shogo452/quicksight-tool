#!/bin/bash

# To create .env and describe AWS_ACCOUNT_ID, USER_ARNS, DASHBOARD_IDS.
SCRIPT_DIR=$(cd $(dirname $0); pwd)
source $SCRIPT_DIR/.env

IFS=$'\n'
echo "========================================== Users =============================================="
echo "${USER_ARNS[@]}"
echo "========================================== Dashboards ==========================================="
echo "${DASHBOARD_IDS[@]}"
echo "================================================================================================="

while true; do
    read -p "Do you wish to revoke reader permissions to the users for the dashboards? (y/n): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done

for user_arn in "${USER_ARNS[@]}" ; do
  for dashboard_id in "${DASHBOARD_IDS[@]}" ; do
    aws quicksight update-dashboard-permissions \
              --aws-account-id $AWS_ACCOUNT_ID \
              --dashboard-id ${dashboard_id} \
              --revoke-permissions Principal=${user_arn},,Actions=quicksight:DescribeDashboard,quicksight:ListDashboardVersions,quicksight:QueryDashboard
  done
done

echo 'Please input your profile.'
echo -n 'PROFILE: '
read profile

if [ $profile = 'ngydv' ]; then
  for user_arn in "${USER_ARNS[@]}" ; do
    for dashboard_id in "${DASHBOARD_IDS[@]}" ; do
      aws quicksight update-dashboard-permissions \
                --aws-account-id $AWS_ACCOUNT_ID \
                --dashboard-id ${dashboard_id} \
                --revoke-permissions Principal=${user_arn},Actions=quicksight:DescribeDashboard,quicksight:ListDashboardVersions,quicksight:QueryDashboard | jq .
    done
  done
else
  for user_arn in "${USER_ARNS[@]}" ; do
    for dashboard_id in "${DASHBOARD_IDS[@]}" ; do
      aws quicksight update-dashboard-permissions \
                --aws-account-id $AWS_ACCOUNT_ID \
                --profile $profile
                --dashboard-id ${dashboard_id} \
                --revoke-permissions Principal=${user_arn},Actions=quicksight:DescribeDashboard,quicksight:ListDashboardVersions,quicksight:QueryDashboard | jq .
    done
  done
fi

#!/usr/bin/env bash

KEY_PAIR=${KEY_PAIR:-"My SSH Key"}
LOG_URI=${LOG_URI:-"s3://plambert-bucket/ds-1004/logs/"}
BOOTSTRAP_ACTION="s3://plambert-bucket/ds-1004/bootstrap-actions/install-dependencies.sh"

set -e

aws emr create-cluster --name "DS-1004" --release-label emr-4.6.0 \
    --use-default-roles --ec2-attributes KeyName="'$KEY_PAIR'" \
    --instance-count 3 --instance-type m3.xlarge \
    --log-uri $LOG_URI \
    --bootstrap-action Path=$BOOTSTRAP_ACTION

#!/usr/bin/env bash
# This file pushes the current committed version of the 
# container to the gigster elastic container registry (ecr)
# so it can be used on kubernetes
#
# This file should be usable in its current form
#
# Pre-reqs:
#   Variables $AWS_DEFAULT_REGION, $AWS_ACCOUNT_ID must be set
#   in your circleci settings, which is done through the admin
#   console for this script to run properly 
#
# Note:
#  The values of $CIRCLE_PROJECT_REPONAME and $CIRCLE_SHA1 are
#  managed by circleci, and you do not have to set them
#  explicitly

# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

configure_aws_cli(){
    aws --version
    aws configure set default.region $AWS_DEFAULT_REGION
    aws configure set default.output json
}

push_ecr_image(){
    eval $(aws ecr get-login --region $AWS_DEFAULT_REGION)
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$CIRCLE_PROJECT_REPONAME:$CIRCLE_SHA1
}

configure_aws_cli
push_ecr_image

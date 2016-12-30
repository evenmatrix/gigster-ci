#!/usr/bin/env bash

# This file pushes the current committed version of the
# container to the gigster elastic container registry (ecr)
# then deploys the file to your configured kubernetes cluster
#
# This file should be usable in its current form
#
# Pre-reqs:
#   The following environment variables must be set in your circleci’s projects settings
#     + AWS_DEFAULT_REGION
#     + AWS_ACCOUNT_ID  
#     + K8S_CERTIFICATE_AUTHORITY_DATA
#     + K8S_CLIENT_CERTIFICATE_DATA
#     + K8S_CLIENT_KEY_DATA
#     + K8S_NAME
#     + K8S_SERVER
#
#   These are all defined in more detail in Step 5.6.3 of Gigster standard deployment process guide.
#
#   You must have also added AWS credentials to your circleci’s project’s settings 
#
# Note:
#  The values of $CIRCLE_PROJECT_REPONAME and $CIRCLE_BUILD_NUM are
#  managed by circleci, and you do not have to set them
#  explicitly

# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

# creates the kubenconfig file required to enable circleci to update your kubernetes
# deployment. It works by taking the environment variables set up in your circle.yml
# file (described in step 5.7 of the Gigster standard deployment process guide) and
# and merging them with the kubeconfig.yml.template
k8s_config(){
    envsubst < k8s/kubeconfig.yml.template > k8s/kubeconfig.yml
}

# below command updates the image used by the kubernetes deployment to point to the 
# most recent  build of your docker container
k8s_deploy(){
   kubectl set image deployment/$CIRCLE_PROJECT_REPONAME $CIRCLE_PROJECT_REPONAME=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BUILD_NUM
}

# Configures the AWS CLI
configure_aws_cli(){
    aws --version
    aws configure set default.region $AWS_DEFAULT_REGION
    aws configure set default.output json
}

# pushes the ECR image to the AWS elastic container registry (ECR)
push_ecr_image(){
    # line below genereates the ecr login, and then uses eval to execute it
    eval $(aws ecr get-login --region $AWS_DEFAULT_REGION)
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BUILD_NUM
}

# calls each method defined above in the correct sequence
configure_aws_cli
push_ecr_image
k8s_config
k8s_deploy

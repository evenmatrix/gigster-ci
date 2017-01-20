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
#
# --- Below environment variables are for kubernetes deployments ---#
#     You'll need to set K8S_DEPLOY=TRUE in CircleCI project settings
#     for the kubernetes deployments steps to execute.
#
#     + K8S_DEPLOY
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
# and merging them with the kubeconfig.yml.template.
# only used if K8S_DEPLOY = "TRUE"
k8s_config(){
    envsubst < k8s/kubeconfig.yml.template > k8s/kubeconfig.yml
    envsubst < k8s/deployment.yml > k8s/deployment-merged.yml
}

# below command updates the image used by the kubernetes deployment to point to the 
# most recent  build of your docker container.
# only used if K8S_DEPLOY = "TRUE"
k8s_deploy(){
   kubectl apply -f k8s/deployment-merged.yml 
}

heroku_deploy(){
    [[ ! -s \"$(git rev-parse --git-dir)/shallow\" ]] || git fetch --unshallow
    git push git@heroku.com:$HEROKU_APP_NAME.git $CIRCLE_SHA1:refs/heads/master
}

ecs_deploy(){
    envsubst < docker-compose.yml.template > docker-compose.yml
    export PATH=$PWD:$PATH
    ecs-cli configure --region $AWS_DEFAULT_REGION --cluster $ECS_CLUSTER
    ecs-cli compose \
    --project-name $CIRCLE_USERNAME-$CIRCLE_PROJECT_REPONAME \
    --file docker-compose.yml \
    up
}

# Configures the AWS CLI
configure_aws_cli(){
    aws --version
    aws configure set default.region $AWS_DEFAULT_REGION
    aws configure set default.output json
}

# pushes the ECR image to the AWS elastic container registry (ECR)
# only used if K8S_DEPLOY = "TRUE"
push_ecr_image(){
    # line below generates the ecr login command, and then uses eval to execute it
    eval $(aws ecr get-login --region $AWS_DEFAULT_REGION)
    docker tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BUILD_NUM $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$CIRCLE_PROJECT_REPONAME:latest
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BUILD_NUM
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$CIRCLE_PROJECT_REPONAME:latest
}

configure_aws_cli
push_ecr_image

# use below for kubernetes deployments
if [ "$K8S_DEPLOY" == "TRUE" ]; then
    k8s_config
    k8s_deploy
fi

if [ "$HEROKU_DEPLOY" == "TRUE" ]; then
    heroku_deploy
fi

if [ "$ECS_DEPLOY" == "TRUE" ]; then
   ecs_deploy
fi

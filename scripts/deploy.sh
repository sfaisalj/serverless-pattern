#!/bin/bash
api_name=$API_NAME
if ! aws cloudformation describe-stacks --stack-name $api_name; then
  export STAGE=development; aws cloudformation create-stack --stack-name $api_name --template-body file://api.yaml --parameters ParameterKey=DeploymentStage,ParameterValue=$STAGE ParameterKey=S3CodeBucket,ParameterValue=$S3_BUCKET ParameterKey=SubnetIds,ParameterValue=$SUBNET_ID ParameterKey=SecurityGroupIds,ParameterValue=$SECURITY_GROUP_ID --capabilities CAPABILITY_NAMED_IAM && aws cloudformation wait stack-create-complete --stack-name $api_name
else
  export STAGE=development; aws cloudformation update-stack --stack-name $api_name --template-body file://api.yaml --parameters ParameterKey=DeploymentStage,ParameterValue=$STAGE ParameterKey=S3CodeBucket,ParameterValue=$S3_BUCKET ParameterKey=SubnetIds,ParameterValue=$SUBNET_ID ParameterKey=SecurityGroupIds,ParameterValue=$SECURITY_GROUP_ID --capabilities CAPABILITY_NAMED_IAM && aws cloudformation wait stack-update-complete --stack-name $api_name
fi
api_outputs=$(aws cloudformation describe-stacks --stack-name $api_name | jq '.["Stacks"][0].Outputs')
restapiid=$(echo ${api_outputs} | jq --raw-output '.[] | select(.ExportName == "RestApi") | .OutputValue')
restapi_deployment=$(aws apigateway create-deployment --rest-api-id ${restapiid} --stage-name $STAGE)
echo $restapi_deployment

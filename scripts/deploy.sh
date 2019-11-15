#!/bin/bash
if ! aws cloudformation describe-stacks --stack-name buynow-api; then
  export STAGE=development; aws cloudformation create-stack --stack-name buynow-api --template-body file://api.yaml --parameters ParameterKey=DeploymentStage,ParameterValue=$STAGE ParameterKey=Timestamp,ParameterValue=$TIMESTAMP --capabilities CAPABILITY_NAMED_IAM && aws cloudformation wait stack-create-complete --stack-name buynow-api
else
  export STAGE=development; aws cloudformation update-stack --stack-name buynow-api --template-body file://api.yaml --parameters ParameterKey=DeploymentStage,ParameterValue=$STAGE ParameterKey=TimeStamp,ParameterValue=$TIMESTAMP --capabilities CAPABILITY_NAMED_IAM && aws cloudformation wait stack-update-complete --stack-name buynow-api
fi
buynow_api=$(aws cloudformation describe-stacks --stack-name buynow-api | jq '.["Stacks"][0].Outputs')
restapiid=$(echo ${buynow_api} | jq --raw-output '.[] | select(.ExportName == "RestApi") | .OutputValue')
restapi_deployment=$(aws apigateway create-deployment --rest-api-id ${restapiid} --stage-name $STAGE)
echo $restapi_deployment

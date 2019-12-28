#!/usr/bin/env bash

echo "===> [Start] Copy python dependencies"
cp -Rf /usr/local/lib/python3.6/site-packages lambda_files/python-packages
echo "===> [End] Copy python dependencies"

echo "===> [Start] Compact files"

rm -rf lambda_files/lambda_locust.zip
zip -q -r lambda_files/lambda_locust.zip lambda_locust.py locustfiles lambda_files/python-packages
rm -rf lambda_files/python-packages

echo "===> [End] Compact files"

echo "===> [Start] Send files to S3"

aws s3api head-bucket --bucket "$S3_BUCKET_NAME"

if [ "$?" -gt 0 ]
then
    aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --create-bucket-configuration LocationConstraint="$AWS_DEFAULT_REGION"
fi

aws s3 sync --delete lambda_files/ s3://"$S3_BUCKET_NAME"/

echo "===> [End] Send files to S3"

echo "===> [Start] Create aws lambda function"

aws lambda get-function --function-name "$FUNCTION_NAME"

if [ "$?" -gt 0 ]
then
    aws lambda create-function --function-name "$FUNCTION_NAME" --timeout "$FUNCTION_TIMEOUT" --memory-size "$FUNCTION_MEMORY" --runtime python3.6 --role "$FUNCTION_ROLE" --handler lambda_locust.handler --code S3Bucket="$S3_BUCKET_NAME",S3Key=lambda_locust.zip
else
    aws lambda update-function-configuration --function-name "$FUNCTION_NAME" --timeout "$FUNCTION_TIMEOUT" --memory-size "$FUNCTION_MEMORY" --role "$FUNCTION_ROLE"
    aws lambda update-function-code --function-name "$FUNCTION_NAME" --s3-bucket "$S3_BUCKET_NAME" --s3-key lambda_locust.zip
fi

echo "===> [End] Create aws lambda function"

s3_bucket=$S3_BUCKET
for i in $(find . -name '*.yml'); do
    filename=$(basename $i)
    directory=$(dirname $i)
    yml_to_yaml=${filename/yml/yaml}
    path_for_compiled_templates='templates/'$yml_to_yaml
    echo $path_for_compiled_templates
    sam build -s $directory -t $i
    sam package --template-file $i --s3-bucket $s3_bucket --output-template-file $path_for_compiled_templates
    #aws cloudformation package --template-file $i --s3-bucket $s3_bucket --output-template-file $path_for_compiled_templates
done
aws s3 cp templates s3://$s3_bucket --recursive
rm -rf .aws-sam/

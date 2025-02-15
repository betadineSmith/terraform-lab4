# Crear el Bucket S3 (Privado):
aws s3api create-bucket \
    --bucket lab4-terraform-state-backend \
    --create-bucket-configuration LocationConstraint=eu-west-3

# Bloquear el acceso público del bucket:
aws s3api put-public-access-block --bucket lab4-terraform-state-backend --public-access-block-configuration \
'{
  "BlockPublicAcls": true,
  "IgnorePublicAcls": true,
  "BlockPublicPolicy": true,
  "RestrictPublicBuckets": true
}'

# Habilitar cifrado AES256 en el bucket:
aws s3api put-bucket-encryption --bucket lab4-terraform-state-backend --server-side-encryption-configuration \
'{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'

# Aplicar tags al bucket S3:
export TAG_SPEC=$(jq -c '{TagSet: [.[] | {Key: .Key, Value: .Value}]}' tags.json)
aws s3api put-bucket-tagging --bucket lab4-terraform-state-backend --tagging "$TAG_SPEC"

# Verificar configuraciones:
aws s3api get-public-access-block --bucket lab4-terraform-state-backend
aws s3api get-bucket-encryption --bucket lab4-terraform-state-backend
aws s3api get-bucket-tagging --bucket lab4-terraform-state-backend


# Crear la tabla DynamoDB para bloqueo de Terraform:
export TAGS=$(jq -r '.[] | "Key=\(.Key),Value=\(.Value)"' tags.json | xargs)
aws dynamodb create-table \
    --table-name lab4-terraform-state \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --tags $TAGS

# Verificar que la tabla tiene los tags correctos:
aws dynamodb list-tags-of-resource \
	--resource-arn arn:aws:dynamodb:eu-west-3:412381763957:table/lab4-terraform-state


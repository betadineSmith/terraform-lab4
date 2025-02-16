#!/bin/bash

# Verificar si jq está instalado
if ! command -v jq &> /dev/null; then
    echo "ERROR: jq no está instalado. Por favor, instálalo antes de ejecutar el script."
    exit 1
fi

# Verificar si el archivo de tags existe
if [ ! -f ../tags.json ]; then
    echo "ERROR: El archivo ../tags.json no existe. No se pueden aplicar tags."
    exit 1
fi

# Definir el bucket y la tabla DynamoDB
BUCKET_NAME="lab4-terraform-state-backend"
DYNAMODB_TABLE="lab4-terraform-state"
AWS_REGION="eu-west-3"

# Verificar si el bucket S3 ya existe
if aws s3api head-bucket --bucket "$BUCKET_NAME" >/dev/null 2>&1; then
    echo "El bucket $BUCKET_NAME ya existe. No se realizarán cambios en él."
else
    echo "Creando bucket $BUCKET_NAME..."
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$AWS_REGION" \
        --create-bucket-configuration LocationConstraint="$AWS_REGION"

    echo "Configurando seguridad del bucket $BUCKET_NAME..."
    aws s3api put-public-access-block --bucket "$BUCKET_NAME" --public-access-block-configuration '{
      "BlockPublicAcls": true,
      "IgnorePublicAcls": true,
      "BlockPublicPolicy": true,
      "RestrictPublicBuckets": true
    }'

    aws s3api put-bucket-encryption --bucket "$BUCKET_NAME" --server-side-encryption-configuration '{
      "Rules": [
        {
          "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "AES256"
          }
        }
      ]
    }'

    echo "Aplicando tags al bucket..."
    export TAG_SPEC=$(jq -c '{TagSet: [.[] | {Key: .Key, Value: .Value}]}' ../tags.json)
    aws s3api put-bucket-tagging --bucket "$BUCKET_NAME" --tagging "$TAG_SPEC"
fi

# Verificar si la tabla DynamoDB ya existe
if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" > /dev/null 2>&1; then
    echo "La tabla $DYNAMODB_TABLE ya existe. Omitiendo creación."
else
    echo "Creando tabla DynamoDB $DYNAMODB_TABLE..."
    export TAGS=$(jq -r '.[] | "Key=\(.Key),Value=\(.Value)"' ../tags.json | xargs)
    aws dynamodb create-table \
        --table-name "$DYNAMODB_TABLE" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --tags $TAGS
fi

# Verificación final del bucket S3 y DynamoDB
echo "Verificando configuraciones del bucket $BUCKET_NAME..."
aws s3api get-public-access-block --bucket "$BUCKET_NAME"
aws s3api get-bucket-encryption --bucket "$BUCKET_NAME"
aws s3api get-bucket-tagging --bucket "$BUCKET_NAME"

# Obtener el ARN de la tabla DynamoDB de forma automática
TABLE_ARN=$(aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" | jq -r '.Table.TableArn')

echo "Verificando los tags de la tabla DynamoDB usando su ARN..."
aws dynamodb list-tags-of-resource --resource-arn "$TABLE_ARN"

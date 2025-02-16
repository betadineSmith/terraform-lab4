# Terraform AWS Lab 4

## Configuración Inicial

Este proyecto usa Terraform para desplegar infraestructura en AWS en la región eu-west-3 (París).

Antes de empezar, se han creado manualmente los siguientes recursos en AWS:

1. Bucket S3: lab4-terraform-state-backend  
   - Se usa para almacenar el estado de Terraform.  
   - Está cifrado con AES-256.  
   - Tiene acceso público bloqueado.  

2. Tabla DynamoDB: lab4-terraform-state  
   - Se usa para bloquear el estado y evitar modificaciones concurrentes.  

## Scripts de Creación Manual

Antes de iniciar Terraform, es necesario crear el **Bucket S3** y la **tabla DynamoDB** para almacenar el estado.  
Se ha añadido un script en `scripts/create_s3_dynamodb.sh` que automatiza este proceso.

### Para ejecutarlo:

bash scripts/create_s3_dynamodb.sh


## Configuración de Terraform

Los archivos base son:
- backend.tf → Configura el backend de Terraform en S3.  
- provider.tf → Define el proveedor AWS en la región eu-west-3.  

## Configuración de Git

Para evitar subir archivos innecesarios al repositorio, se ha añadido un archivo `.gitignore` con las siguientes reglas:

- `.terraform/` → Carpeta donde Terraform guarda plugins y archivos temporales.  
- `.terraform.lock.hcl` → Archivo de bloqueo de versiones del proveedor de Terraform.  

Estos archivos son generados automáticamente por Terraform y no deben subirse al repositorio.  

## Se ha desarrollado un módulo en Terraform para gestionar la infraestructura de red en AWS, con las siguientes características:

- VPC con el CIDR 10.0.0.0/16.
- 2 Subnets Públicas y 2 Subnets Privadas, distribuidas en diferentes zonas de disponibilidad (AZs).
- Internet Gateway (IGW) para permitir la salida a internet desde la VPC.
- 2 NAT Gateways, cada uno en una subnet pública, con su propia tabla de rutas privada, asegurando la salida a internet de las subnets privadas.
- Tablas de rutas segmentadas, con cada subnet pública teniendo su propia tabla de rutas asociada al IGW y cada subnet privada asociada a un NAT Gateway específico.
- Etiquetas unificadas para todos los recursos, cargadas dinámicamente desde el archivo tags.json.


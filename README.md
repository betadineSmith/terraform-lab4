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

## Configuración de Terraform

Los archivos base son:
- backend.tf → Configura el backend de Terraform en S3.  
- provider.tf → Define el proveedor AWS en la región eu-west-3.  

## Configuración de Git

Para evitar subir archivos innecesarios al repositorio, se ha añadido un archivo `.gitignore` con las siguientes reglas:

- `.terraform/` → Carpeta donde Terraform guarda plugins y archivos temporales.  
- `.terraform.lock.hcl` → Archivo de bloqueo de versiones del proveedor de Terraform.  

Estos archivos son generados automáticamente por Terraform y no deben subirse al repositorio.  
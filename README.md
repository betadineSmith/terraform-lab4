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

## Implementación de la Seguridad (Security Groups)

Se ha desarrollado un módulo en Terraform para gestionar los **Security Groups (SG)** de los distintos componentes de la infraestructura.

Cada **Security Group** ha sido creado inicialmente **sin reglas**, y las reglas de tráfico serán añadidas posteriormente según los requisitos de cada servicio.

###  **Security Groups creados:**
- **SG para RDS PostgreSQL** → `lab4-rds-sg`
- **SG para ElasticCache Redis** → `lab4-redis-sg`
- **SG para los Microservicios en ECS** → `lab4-ecs-sg`
- **SG para el Application Load Balancer (ALB - Externo)** → `lab4-alb-sg`
- **SG para el Network Load Balancer (NLB - Interno)** → `lab4-nlb-sg`
- **SG para EFS (Elastic File System)** → `lab4-efs-sg`

###  **Consideraciones:**
- Todos los SGs han sido creados dentro de la **VPC principal** y con los **tags unificados** de `tags.json`.  
- Se han definido **outputs** en Terraform para poder referenciar cada SG en otros módulos.
- Las **reglas de seguridad** se definirán en una fase posterior según los requisitos de conectividad de cada servicio.

## Implementación de la Base de Datos en RDS

Se ha añadido un módulo en Terraform para la creación y gestión de una instancia de **Amazon RDS con PostgreSQL**.  

### Características del Módulo RDS:
- **Motor:** PostgreSQL  
- **Instancia Multi-AZ:** Activado para alta disponibilidad  
- **Copia de Seguridad:** Retención de backups durante 2 días  
- **Acceso Público:** Desactivado, la base de datos es privada  
- **Grupo de Subnets:** Se han definido subnets privadas para el despliegue  
- **Gestión de Credenciales:** Se usa AWS Secrets Manager para almacenar la contraseña del usuario administrador de la base de datos  
- **Security Group:** Se asocia al Security Group `lab4-rds-sg`, definido en el módulo de seguridad  
- **Etiquetas:** Se aplican automáticamente a todos los recursos creados  

### Outputs del Módulo:
Tras la creación de la instancia, Terraform devuelve los siguientes valores:
- **Endpoint de conexión** a la base de datos  
- **ARN del secreto en AWS Secrets Manager**, que almacena las credenciales  
Estos valores son utilizados por otros módulos para la integración con microservicios u otros sistemas.  

Este módulo garantiza una infraestructura segura y escalable para la base de datos PostgreSQL.  

# Terraform AWS Lab 4

Acesso a través de ROL
**arn:aws:iam::412381763957:role/ReadOnlyAccessForEsteveAlquezar**

## Configuración Inicial

Este proyecto usa Terraform para desplegar infraestructura en AWS en la región eu-west-3 (París).
Usa una ami personalizada en dicha región ami-0091da954fd26a2bc (lab4-AMI-Drupal-inicial)
Y dos certificados validos del dominio jmbmcloud.com en (eu-west-3 (París) - us-east-1 N.Virginia)

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

Al final se han unificado esos dos fichemros dentro del main.tf

## Configuración de Git

Para evitar subir archivos innecesarios al repositorio, se ha añadido un archivo `.gitignore` con las siguientes reglas:

- `.terraform/` → Carpeta donde Terraform guarda plugins y archivos temporales.  
- `.terraform.lock.hcl` → Archivo de bloqueo de versiones del proveedor de Terraform.  

Estos archivos son generados automáticamente por Terraform y no deben subirse al repositorio.  

## Módulo en Terraform para gestionar la infraestructura de red en AWS

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

## Implementación de ElastiCache Redis

Se ha añadido un módulo en Terraform para gestionar **ElastiCache Redis** con la siguiente configuración:

- **Cluster Redis con alta disponibilidad (Multi-AZ)**
  - Se crea un **Primary Node** y una **Replica** en diferentes zonas de disponibilidad.
  - Se habilita **Automatic Failover** para asegurar la continuidad en caso de fallo.

- **Grupo de Subnets Privadas**
  - El cluster se despliega en las **subnets privadas** dentro de la VPC.
  - Se ha creado un **ElastiCache Subnet Group** para asociar correctamente las subnets.

- **Seguridad**
  - Se asocia el **Security Group de Redis**, permitiendo el acceso controlado.
  - Este SG se conectará con los microservicios en ECS y la base de datos RDS.

- **Configuración de los nodos**
  - Se ha utilizado una instancia de tipo `cache.t4g.micro`, optimizada para Redis.
  - Un único **Node Group**, con 1 **Primary Node** y 1 **Replica**.

- **Tags unificados**
  - Se aplican las mismas etiquetas (`tags.json`) a todos los recursos de Redis.

## Implementación de Elastic File System (EFS)

Se ha añadido soporte para **AWS Elastic File System (EFS)** dentro de la infraestructura, proporcionando almacenamiento compartido y escalable para los microservicios.  

### **Configuración del Módulo de EFS**
El módulo de Terraform configura un **EFS** con las siguientes características:

- **Accesible desde las Subnets Privadas** dentro de la VPC.
- **Asociado a un Security Group** para controlar el tráfico de red.
- **Gestión Automática de Capacidad**, sin necesidad de definir un tamaño fijo.
- **Integración con ECS Fargate y otros servicios** que necesiten almacenamiento persistente.

### **Outputs Generados**
Después de la implementación, Terraform proporciona la siguiente información clave:

- **DNS de Montaje** → Punto de acceso para conectar EFS con otras instancias o contenedores.

###  **Ejemplo de Montaje Manual en EC2**
Si deseas probar el montaje manualmente desde una instancia EC2:

```sh
sudo yum install -y amazon-efs-utils
sudo mkdir -p /mnt/efs
sudo mount -t efs <efs_dns_name>:/ /mnt/efs
```

### Configuración de Route 53 (Zona Privada y Registros)

Se ha creado un módulo en Terraform para gestionar una **Zona Privada en Route 53** dentro de la VPC. Esto permite la resolución interna de nombres de dominio para los distintos servicios desplegados en la infraestructura.

#### Recursos creados:
- **Zona Privada en Route 53** con el dominio `lab4.internal.`
- **Registros CNAME internos** para resolver más fácilmente los endpoints de los servicios:
  - `rds.lab4.internal` → **Base de datos RDS PostgreSQL**
  - `redis.lab4.internal` → **Redis Primary (lectura/escritura)**
  - `redis-ro.lab4.internal` → **Redis Replica (solo lectura)**
  - `efs.lab4.internal` → **Elastic File System (EFS)**

#### Beneficios:
- Simplifica la conectividad de los servicios internos, permitiendo que ECS y otros componentes puedan acceder por nombres de dominio en lugar de direcciones IP.
- Facilita la administración de recursos sin depender de direcciones dinámicas.
- Se pueden añadir más registros en el futuro si se despliegan nuevos servicios.

## Módulo S3 + CloudFront

Este módulo implementa una solución optimizada para almacenamiento y distribución de imágenes estáticas.

### Funcionalidad:
- **S3 (Simple Storage Service)**: Almacena imágenes de forma privada.
- **CloudFront (CDN)**: Sirve imágenes desde ubicaciones optimizadas para mejorar el rendimiento y reducir la latencia.
- **OAC (Origin Access Control)**: Garantiza que solo CloudFront puede acceder al bucket.
- **Caché optimizada**: Se utiliza la política de caché administrada de AWS.

### Recursos creados:
1. **Bucket S3 privado** (`lab4-s3-images`)  
2. **Distribución CloudFront** (con caché optimizado)  
3. **Política de acceso restringido en S3**  
4. **Configuración de OAC en CloudFront**  

### Outputs:
- **S3 Bucket URL** → Se usa para que la aplicación pueda subir imágenes.  
- **CloudFront URL** → Se usa para servir imágenes en la aplicación.

# Módulo de Load Balancer (ALB/NLB)

Este módulo de Terraform crea un Application Load Balancer (ALB) o un Network Load Balancer (NLB) en AWS, junto con sus Listeners y configuraciones asociadas.

## Características

- Soporta la creación de ALB o NLB según el tipo definido en `var.lb_type`.
- Permite la configuración de Listeners HTTP (80) y HTTPS (443) para ALB.
- Configuración automática de redirección HTTP a HTTPS si `enable_https` está activado.
- Soporte para múltiples puertos TCP en NLB a través de `var.lb_listener_ports`.
- Integración con AWS ACM para el manejo automático de certificados SSL.
- Se pueden definir etiquetas (`tags`) para todos los recursos.

## Variables de Entrada

| Nombre                          | Descripción                                               | Tipo      | Valor por defecto  |
|----------------------------     |---------------------------------------------------------- |-----------|--------------------|
| `load_balancer_name`            | Nombre del Load Balancer.                                 | `string`  | -                  |
| `lb_visibility`                 | Tipo de visibilidad (`internal` o `external`).            | `string`  | `external`         |
| `lb_type`                       | Tipo de Load Balancer (`application` o `network`).        | `string`  | `application`      |
| `load_balancer_subnets`         | Lista de subnets donde desplegar el Load Balancer.        | `list`    | -                  |
| `load_balancer_security_group`  | ID del Security Group del Load Balancer.                  | `string`  | -                  |
| `enable_https`                  | Habilitar HTTPS en ALB (`true` o `false`).                | `bool`    | `false`            |
| `certificate_arn`               | ARN del certificado SSL en ACM.                           | `string`  | -                  |
| `lb_listener_ports`             | Lista de puertos a configurar en NLB.                     | `list`    | `[]`               |
| `tags`                          | Mapa de etiquetas a aplicar en los recursos.              | `map`     | `{}`               |

## Outputs

| Nombre                    | Descripción                                                  |
|---------------------------|--------------------------------------------------------------|
| `load_balancer_arn`       | ARN del Load Balancer creado (ALB o NLB).                    |
| `http_listener_arn`       | ARN del Listener HTTP en ALB (si aplica).                    |
| `https_listener_arn`      | ARN del Listener HTTPS en ALB (si aplica).                   |
| `nlb_listeners_arns`      | Lista de ARNs de los Listeners TCP en NLB (si aplica).       | 

## Uso del Módulo

Ejemplo de cómo incluir este módulo en `main.tf`:

```hcl
module "alb_external" {
  source                     = "./modules/load_balancer"
  load_balancer_name         = "mi-load-balancer"
  lb_visibility              = "external"
  lb_type                    = "application"
  load_balancer_subnets      = ["subnet-12345678", "subnet-87654321"]
  load_balancer_security_group = "sg-0123456789abcdef"
  enable_https               = true
  lb_listener_ports          = [80, 443]
  tags                       = { Environment = "dev" }
}
```

# Módulo de Route 53 - Zona Pública

Este módulo de Terraform crea una **zona pública en AWS Route 53** y configura **registros ALIAS** para apuntar a un **Application Load Balancer (ALB)**.

## Características

- **Crea una zona pública en Route 53** para el dominio proporcionado.
- **Registros ALIAS para el Load Balancer**:
  - `jmbmcloud.com` → Apunta al Load Balancer.
  - `www.jmbmcloud.com` → Apunta al Load Balancer.
- **Soporta etiquetas (`tags`)** para la zona pública.

---

## Variables de Entrada

| Nombre         | Descripción                                      | Tipo       | Requerido |
|---------------|--------------------------------------------------|------------|-----------|
| `domain_name` | Nombre del dominio para la zona pública.        | `string`   | Sí |
| `alb_dns_name` | Nombre DNS del Load Balancer (ALB).            | `string`   | Sí |
| `alb_zone_id` | ID de la zona del Load Balancer (para ALIAS).    | `string`   | Sí |
| `tags`        | Mapa de etiquetas para la zona pública.         | `map`      | No (opcional) |

---

## Uso del Módulo

Ejemplo de cómo incluir este módulo en `main.tf`:

```hcl
module "route53_public" {
  source       = "./modules/route53_public"
  domain_name  = "jmbmcloud.com"
  alb_dns_name = module.alb_external.load_balancer_dns_name
  alb_zone_id  = module.alb_external.load_balancer_zone_id
  tags = {
    Environment = "Production"
    Project     = "WebApp"
  }
}
```

### Terraform Module: VPC Peering

#### Descripción
Este módulo de Terraform establece una conexión de **VPC Peering** entre dos VPCs en AWS y configura las rutas necesarias para la comunicación.

---

## **Recursos Creado por el Módulo**
- `aws_vpc_peering_connection`: Crea la conexión de VPC Peering.
- `aws_route`: Configura las rutas en ambas VPCs para permitir la comunicación.

---

## **Uso del Módulo**
```hcl
module "vpc_peering" {
  source = "./modules/vpc_peering"

  vpc_id             = module.network.vpc_id
  peer_vpc_id        = module.network_backup.vpc_id
  vpc_cidr           = var.vpc_cidr
  peer_vpc_cidr      = var.vpc_cidr_backup
  route_table_ids_main = module.network.private_route_table_ids
  route_table_ids_peer = module.network_backup.private_route_table_ids

  tags = local.tags
}
```

---

## **Parámetros del Módulo**

| Nombre                   | Descripción                                            | Tipo           | Requerido |
|--------------------------|--------------------------------------------------------|---------------|-----------|
| `vpc_id`                 | ID de la VPC principal                                | `string`      | Yes        |
| `peer_vpc_id`            | ID de la VPC de backup                               | `string`      | Yes       |
| `vpc_cidr`               | CIDR de la VPC principal                             | `string`      | Yes        |
| `peer_vpc_cidr`          | CIDR de la VPC de backup                            | `string`      | Yes        |
| `route_table_ids_main`   | Lista de tablas de rutas de la VPC principal        | `list(string)`| Yes       |
| `route_table_ids_peer`   | Lista de tablas de rutas de la VPC de backup        | `list(string)`| Yes       |
| `auto_accept`            | Aceptar automáticamente el peering (default: `true`) | `bool`        | No        |
| `tags`                   | Etiquetas a aplicar en los recursos                  | `map(string)` | No        |

---

## **Outputs Generados**

| Nombre          | Descripción                                    |
|----------------|------------------------------------------------|
| `peering_id`   | ID de la conexión de peering creada           |
| `main_vpc_routes` | Rutas creadas en la VPC principal           |
| `peer_vpc_routes` | Rutas creadas en la VPC de backup           |

---

## **Código del Módulo**

### **1️ Creación de la Conexión VPC Peering**
```hcl
resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = var.auto_accept

  tags = merge(var.tags, { Name = "vpc-peering-${var.vpc_id}-${var.peer_vpc_id}" })
}
```

### **2️ Configuración de Rutas en la VPC Principal**
```hcl
resource "aws_route" "peering_route_main" {
  count = length(var.route_table_ids_main)

  route_table_id            = var.route_table_ids_main[count.index]
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
```

### **3 Configuración de Rutas en la VPC de Backup**
```hcl
resource "aws_route" "peering_route_peer" {
  count = length(var.route_table_ids_peer)

  route_table_id            = var.route_table_ids_peer[count.index]
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
```

---

##  **Notas**
- **Las rutas se configuran automáticamente**, no es necesario agregarlas manualmente.
- **Las reglas de seguridad (SGs y NACLs) deben permitir el tráfico entre VPCs** para que la conexión funcione.
- **Si las VPCs están en cuentas diferentes**, la aceptación del peering debe realizarse manualmente si `auto_accept` está deshabilitado.

#  Módulo Terraform: ECS Fargate para Memcached

Este módulo de Terraform implementa un **Cluster ECS Fargate** para desplegar **Memcached** de manera escalable en AWS.

## Características
- **ECS Fargate** con tareas para **Memcached**.
- **Task Definition optimizada** con autoescalado dinámico.
- **Service Discovery** con Route 53 (`fargate.local`).
- **Integración con aplicaciones en ECS o EC2**.
- **Auto Scaling basado en número de instancias**.

---

##  Requisitos
- **Cuenta de AWS con IAM configurado**
- **VPC y subnets privadas para ECS**
- **Route 53 configurado (`fargate.local`)**
- **Cluster ECS existente (`lab4-ECS-Fargate`)**
- **Security Group adecuado para tráfico en el puerto 11211**

---

## Variables de Entrada (`variables.tf`)
| Variable | Descripción | Tipo | Valor por Defecto |
|----------|------------|------|------------------|
| `ecs_cluster_name` | Nombre del cluster ECS | `string` | `"lab4-ECS-Fargate"` |
| `ecs_task_role_arn` | ARN del rol de ejecución de ECS | `string` | `""` |
| `ecs_execution_role_arn` | ARN del rol de ejecución de tareas ECS | `string` | `""` |
| `ecs_subnets` | Subnets privadas donde desplegar Fargate | `list(string)` | `[]` |
| `memcached_sg_id` | ID del Security Group para Memcached | `string` | `""` |
| `service_discovery_namespace_id` | ID del namespace de Service Discovery | `string` | `""` |
| `min_memcached_tasks` | Mínimo de tareas Memcached | `number` | `2` |
| `max_memcached_tasks` | Máximo de tareas Memcached | `number` | `4` |

---

##  Outputs (`outputs.tf`)
| Output | Descripción |
|--------|------------|
| `memcached_service_arn` | ARN del servicio ECS Memcached |
| `memcached_task_definition_arn` | ARN de la Task Definition Memcached |
| `memcached_service_name` | Nombre del servicio ECS Memcached |
| `memcached_service_endpoint` | Endpoint de Memcached (`memcached.fargate.local`) |

---

##  Uso del Módulo
### **Ejemplo de Uso en Terraform**
```hcl
module "ecs_memcached" {
  source = "./modules/ecs_fargate_memcached"

  ecs_cluster_name       = "lab4-ECS-Fargate"
  ecs_execution_role_arn = module.iam_roles.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam_roles.ecs_task_role_arn
  ecs_subnets            = module.network.private_subnet_ids
  memcached_sg_id        = module.security_groups.ecs_mem_sg
  service_discovery_namespace_id = module.service_discovery.namespace_id
  min_memcached_tasks    = 2
  max_memcached_tasks    = 4

  tags = local.tags
}

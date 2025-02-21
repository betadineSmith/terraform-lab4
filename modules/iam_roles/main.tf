# ==============================================
# IAM ROLE PARA ECS EXECUTION
# ==============================================
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ==============================================
# IAM ROLE PARA ECS TASKS
# ==============================================
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

# ==============================================
# CREAR EL ROLE IAM PARA EC2
# ==============================================
resource "aws_iam_role" "general_ec2_role" {
  name = "General-EC2-Role"

  # Permitir que EC2 asuma este rol
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# ==============================================
# CREAR INSTANCE PROFILE Y ASOCIARLO AL ROLE
# ==============================================
resource "aws_iam_instance_profile" "general_ec2_ins_profile" {
  name = "general-EC2-InsProfile"
  role = aws_iam_role.general_ec2_role.name
}

# ==============================================
# CREAR POLÍTICA PERSONALIZADA PARA S3 (Lab4-S3AccessPolicy)
# ==============================================
resource "aws_iam_policy" "s3_access_policy" {
  name        = "Lab4-S3AccessPolicy"
  description = "Permite acceso a S3 para almacenar imágenes en el bucket lab4-s3-images"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::lab4-s3-images",
          "arn:aws:s3:::lab4-s3-images/*"
        ]
      }
    ]
  })
}

# =================================================================================
# CREAR POLÍTICA PERSONALIZADA PARA SECRETS MANAGER (SecretsManagerReadOnlyCustom)
# =================================================================================
resource "aws_iam_policy" "secrets_manager_readonly" {
  name        = "SecretsManagerReadOnlyCustom"
  description = "Permite acceso de solo lectura a Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Resource = "*"
      }
    ]
  })
}

# ==============================================
# ASIGNAR LAS POLÍTICAS AL ROLE EC2
# ==============================================
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.general_ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy" {
  role       = aws_iam_role.general_ec2_role.name
  policy_arn = aws_iam_policy.secrets_manager_readonly.arn
}

# ==============================================
# ADJUNTAR POLÍTICAS AWS MANAGED AL ROLE
# ==============================================
resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
  role       = aws_iam_role.general_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  role       = aws_iam_role.general_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


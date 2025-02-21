resource "aws_secretsmanager_secret" "drupal_secret" {
  name        = "drupal-secret"
  description = "Secret for Drupal database credentials"

tags = merge(var.tags, {
    Name =  "drupal-secret"
  })

}

resource "aws_secretsmanager_secret_version" "drupal_secret_version" {
  secret_id     = aws_secretsmanager_secret.drupal_secret.id
  secret_string = jsonencode({
    username = "drupaluser"
    password = "DrupalP@ssw0rd"
  })
}

#!/bin/bash

LOG_FILE="$(dirname "$0")/script_install.log"
echo "Inicio de instalación: $(date)" | tee -a $LOG_FILE

# Instalación y configuración de Apache
echo "Instalando Apache..." | tee -a $LOG_FILE
sudo yum install -y httpd &>/dev/null
sudo systemctl enable --now httpd &>/dev/null

# Instalación de Amazon EFS Utils y configuración de montaje
echo "Instalando Amazon EFS Utils..." | tee -a $LOG_FILE
sudo yum install -y amazon-efs-utils &>/dev/null

# Instalación de PostgreSQL y PHP con extensiones necesarias

echo "Instalando PostgreSQL y PHP..." | tee -a $LOG_FILE
if sudo yum install -y postgresql16 php php-cli php-common php-mbstring php-xml php-json php-gd php-pdo php-pgsql php-opcache unzip &>/dev/null; then
    echo "PostgreSQL y PHP instalados correctamente." | tee -a $LOG_FILE
else
    echo "Error en la instalación de PostgreSQL y PHP." | tee -a $LOG_FILE
fi

# Instalación de herramientas de desarrollo y compilación

echo "Instalando herramientas de desarrollo..." | tee -a $LOG_FILE
if sudo yum groupinstall -y "Development Tools" &>/dev/null && sudo yum install -y gcc make wget &>/dev/null; then
    echo "Herramientas de desarrollo instaladas correctamente." | tee -a $LOG_FILE
else
    echo "Error en la instalación de herramientas de desarrollo." | tee -a $LOG_FILE
fi

# Instalación de Redis CLI

echo "Instalando Redis CLI..." | tee -a $LOG_FILE
if sudo wget -q http://download.redis.io/redis-stable.tar.gz && sudo tar xzf redis-stable.tar.gz && cd redis-stable && sudo make redis-cli &>/dev/null && sudo cp src/redis-cli /usr/local/bin/ &>/dev/null; then
    echo "Redis CLI instalado correctamente." | tee -a $LOG_FILE
else
    echo "Error en la instalación de Redis CLI." | tee -a $LOG_FILE
fi
cd ..
sudo rm -rf redis-stable redis-stable.tar.gz

# Instalación de herramientas adicionales

echo "Instalando herramientas adicionales..." | tee -a $LOG_FILE
if sudo yum install -y nc libmemcached-awesome-tools python3-pip &>/dev/null && pip3 install pymemcache &>/dev/null; then
    echo "Herramientas adicionales instaladas correctamente." | tee -a $LOG_FILE
else
    echo "Error en la instalación de herramientas adicionales." | tee -a $LOG_FILE
fi

# Instalación y configuración de Redis para PHP

echo "Instalando y configurando Redis para PHP..." | tee -a $LOG_FILE
if sudo yum install -y php-pear php-devel &>/dev/null && yes "" | sudo pecl install redis &>/dev/null; then
    echo "extension=redis.so" | sudo tee -a /etc/php.ini &>/dev/null
    if php -m | grep -q redis; then
        echo "Redis para PHP instalado correctamente." | tee -a $LOG_FILE
    else
        echo "Redis para PHP no se cargó correctamente en PHP." | tee -a $LOG_FILE
    fi
else
    echo "Error en la instalación de Redis para PHP." | tee -a $LOG_FILE
fi

# Instalación y configuración de Memcached para PHP

echo "Instalando y configurando Memcached para PHP..." | tee -a $LOG_FILE
if sudo yum install -y php-pear php-devel gcc libmemcached-devel &>/dev/null && yes "" | sudo pecl install memcached &>/dev/null; then
    echo "extension=memcached.so" | sudo tee -a /etc/php.ini &>/dev/null
    if php -m | grep -q memcached; then
        echo "Memcached para PHP instalado correctamente." | tee -a $LOG_FILE
    else
        echo "Memcached para PHP no se cargó correctamente en PHP." | tee -a $LOG_FILE
    fi
else
    echo "Error en la instalación de Memcached para PHP." | tee -a $LOG_FILE
fi


# Verificación y configuración de fstab
if ! grep -Pq "efs\.lab4\.local:\s+/var/www/html\s+efs\s+_netdev,tls\s+0\s+0" /etc/fstab; then
    echo "Agregando entrada a /etc/fstab..." | tee -a $LOG_FILE
    sudo bash -c 'echo "efs.lab4.local:/ /var/www/html efs _netdev,tls 0 0" >> /etc/fstab'
else
    echo "Entrada ya existente en /etc/fstab, no se agrega nuevamente." | tee -a $LOG_FILE
fi

# Montaje del sistema de archivos
sudo mount /var/www/html &>/dev/null

# Verificación del montaje
if mount | grep -q "/var/www/html"; then
    echo "EFS montado correctamente en /var/www/html" | tee -a $LOG_FILE
else
    echo "Error: No se pudo montar EFS en /var/www/html" | tee -a $LOG_FILE
    exit 1
fi

# Configuración de PostgreSQL y Drupal
SECRET_VALUE=$(aws secretsmanager get-secret-value \
  --secret-id 'rds!db-cbf7ad5e-3809-4165-bcb3-5d123bb44592' \
  --query 'SecretString' \
  --output text)
DB_PASSWORD=$(echo "$SECRET_VALUE" | jq -r '.password')
DB_USERNAME=$(echo "$SECRET_VALUE" | jq -r '.username')

SECRET_VALUE=$(aws secretsmanager get-secret-value \
  --secret-id 'drupal-secret' \
  --query 'SecretString' \
  --output text)

DRUPAL_PASS=$(echo "$SECRET_VALUE" | jq -r '.password')
DRUPAL_USER=$(echo "$SECRET_VALUE" | jq -r '.username')

# Verificar si la base de datos existe
if PGPASSWORD="$DB_PASSWORD" psql -h rds.lab4.local -U "$DB_USERNAME" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='drupaldb';" | grep -q 1; then
    echo "La base de datos 'drupaldb' ya existe." | tee -a $LOG_FILE
else
    echo "La base de datos 'drupaldb' no existe, procediendo a crearla..." | tee -a $LOG_FILE

    # Crear el usuario y la base de datos
    PGPASSWORD="$DB_PASSWORD" psql -h rds.lab4.local -U "$DB_USERNAME" -d postgres <<EOF
    CREATE ROLE $DRUPAL_USER WITH LOGIN ENCRYPTED PASSWORD '$DRUPAL_PASS' NOINHERIT;
    CREATE DATABASE drupaldb WITH OWNER = $DRUPAL_USER ENCODING = 'UTF8';
    \c drupaldb
    GRANT ALL ON SCHEMA public TO $DRUPAL_USER;
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    \q
EOF
    echo "Base de datos 'drupaldb' y usuario '$DRUPAL_USER' creados correctamente." | tee -a $LOG_FILE

    # Restauración de la base de datos
    echo "Restaurando base de datos de Drupal..." | tee -a $LOG_FILE
    PGPASSWORD="$DRUPAL_PASS" psql -U $DRUPAL_USER -h rds.lab4.local -d drupaldb < drupal_db_backup.sql &>/dev/null
    echo "Restauración de la base de datos completada." | tee -a $LOG_FILE
fi

# Verificar si el directorio existe
if [ -d "/var/www/html/drupal" ]; then
    echo "El directorio /var/www/html/drupal ya existe. No se realizarán cambios." | tee -a $LOG_FILE
else
    echo "El directorio /var/www/html/drupal no existe. Procediendo con la instalación..." | tee -a $LOG_FILE

    # Crear el directorio con los permisos adecuados
    echo "Creando directorio /var/www/html/drupal..." | tee -a $LOG_FILE
    sudo mkdir -p /var/www/html/drupal
    sudo chown apache:apache /var/www/html/drupal

    # Restaurando instalación de Drupal
    echo "Restaurando archivos de Drupal..." | tee -a $LOG_FILE
    tar -xzvf drupal_backup.tar.gz -C /var/www/html/drupal &>/dev/null

    echo "Modificando DocumentRoot en httpd.conf..." | tee -a $LOG_FILE
    
    # Ruta del archivo de configuración de Apache
    HTTPD_CONF="/etc/httpd/conf/httpd.conf"

    # Hacer un respaldo del archivo original
    sudo cp "$HTTPD_CONF" "$HTTPD_CONF.bak"

    # Modificar el DocumentRoot y el bloque <Directory>
    sudo sed -i 's|^DocumentRoot .*|DocumentRoot "/var/www/html/drupal"|' "$HTTPD_CONF"
    sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/c\<Directory "/var/www/html/drupal">\n    AllowOverride All\n    Require all granted\n</Directory>' "$HTTPD_CONF"

    # Reiniciar Apache para aplicar cambios
    sudo systemctl restart httpd
    
    echo "Configuración de Apache actualizada y servicio reiniciado." | tee -a $LOG_FILE
fi

# Fin del script
echo "Instalación y configuración completadas." | tee -a $LOG_FILE
echo "Fin del proceso: $(date)" | tee -a $LOG_FILE

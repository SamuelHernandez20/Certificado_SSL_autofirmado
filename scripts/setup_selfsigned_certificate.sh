#!/bin/bash

#Muestra comandos que se van ejecutando por si falla
set -x

# Actualizamos los repositorios:

apt update

# Actualizar paquetes:

#apt upgrade -y

# Importamos ele archivo de variables:

source .env

# Creación del certificado autofirmado y la clave privada

openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"

  #Copiamos el archivo de configuracion de Apache para HTTPS

  cp ../conf/default-ssl.conf /etc/apache2/sites-available/

 # Para habilitar el virtualhost copiado:

  a2ensite default-ssl.conf

# Habilitamos el modulo SSL

  a2enmod ssl

# hacer un restart de apache2:

  systemctl restart apache2

# Configuramos que las peticiones a HTTP se redirijan a HTTPS
# Copiar el archivo conf de VH para HTTP

cp ../conf/000-default.conf /etc/apache2/sites-available/

# Habilitamos el modulo rewrite Apache pueda hacer la redirección de HTTP a HTTPS

a2enmod rewrite

# Reiniciamos el servicio de Apache

systemctl restart apache2

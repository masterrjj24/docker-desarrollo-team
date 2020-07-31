PASOS PARA CONFIGURAR UN ENTORNO DE DESARROLLO USANDO DOCKER

-------------------------------------------------------------------
-------------------------------------------------------------------
PASO 0- INSTALAR DOCKER -
-------------------------------------------------------------------
-------------------------------------------------------------------
https://www.docker.com/products/docker-desktop


-------------------------------------------------------------------
-------------------------------------------------------------------
PASO 1- INSTALAR WEB SERVER (PHP73 + APACHE) con soporte GD webp
-------------------------------------------------------------------
-------------------------------------------------------------------
mkdir myproject && cd myproject
echo -e "" > Dockerfile

// Editar Dockerfile
---
FROM php:7.3-apache
LABEL maintainer="dev@chialab.io"

# Download script to install PHP extensions and dependencies
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      curl \
      git \
    && install-php-extensions \
      bcmath \
      bz2 \
      calendar \
      exif \
      gd \
      intl \
      ldap \
      memcached \
      mysqli \
      opcache \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      redis \
      soap \
      xsl \
      zip \
# already installed:
#      iconv \
#      mbstring \
    && a2enmod rewrite

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1
---

# Construimos la imagen docker que vamos a usar
docker build -t serverimage:v1 .

# La imagen ya está lista, pero aún no crearemos el contenedor docker (asgard-php73-apache)

# Create public_html in development data (poner vuestra ruta preferida. se recomienda dentro de la carpeta home de mac)
mkdir -p /Users/desarrollo/docker_vol/php73apache





-------------------------------------------------------------------
-------------------------------------------------------------------
PASO 2- INSTALAR CONTENEDOR MYSQL
-------------------------------------------------------------------
-------------------------------------------------------------------

# Create the network called "asgard"
docker network create asgard

# Create dir for database data
# (poner vuestra ruta preferida. se recomienda dentro de la carpeta home de mac)
mkdir -p /Users/desarrollo/docker_vol/mysql5729


# Create MySQL container
docker run -d --name asgard-mysql --network asgard -e MYSQL_ROOT_PASSWORD="secret" -v /Users/desarrollo/docker_vol/mysql5729/:/var/lib/mysql -p 3306:3306 mysql:5.7.29




-------------------------------------------------------------------
-------------------------------------------------------------------
PASO 3- INSTALAR CONTENEDOR PHPMYADMIN
-------------------------------------------------------------------
-------------------------------------------------------------------
# Create phpMyAdmin container
docker run -d --name asgard-phpmyadmin --network asgard -e PMA_HOST=asgard-mysql -p 8080:80 phpmyadmin/phpmyadmin:edge




-------------------------------------------------------------------
-------------------------------------------------------------------
PASO 4- LANZAR SERVIDOR WEB Y LINKEAR SERVIDOR WEB CON MYSQL
Aquí es cuando se crea el contenedor docker del servidor web llamado: asgard-php73-apache
-------------------------------------------------------------------
-------------------------------------------------------------------
docker run -d -p 8888:80 -v /Users/desarrollo/docker_vol/php73apache/:/var/www/html --name asgard-php73-apache --network asgard --link asgard-mysql serverimage:v1




-------------------------------------------------------------------
-------------------------------------------------------------------
PASO 5- ARRANCAR DETENER SERVIDORES DOCKER
-------------------------------------------------------------------
-------------------------------------------------------------------
docker kill asgard-phpmyadmin asgard-mysql asgard-php73-apache

docker start asgard-phpmyadmin asgard-mysql asgard-php73-apache


Finalmente configuramos phpinfo: Para esto hay que arrancar una consola de comandos en el contenedor. (La puedes lanzar desde docker desktop)
---
# Set SERVER_ADMIN para file_class_config modo desarrollo
apt-get update
apt-get install vim
# phpinfo(); nos indica que el email configurado en local es: webmaster@localhost
# buscamos en qué archivo está configurado ese email
grep -R "webmaster@localhost*" /etc
---
grep: /etc/alternatives/builtins.7.gz: No such file or directory
grep: /etc/alternatives/awk.1.gz: No such file or directory
grep: /etc/alternatives/nawk.1.gz: No such file or directory
grep: /etc/alternatives/rmt.8.gz: No such file or directory
/etc/apache2/sites-available/000-default.conf: ServerAdmin webmaster@localhost
/etc/apache2/sites-available/default-ssl.conf: ServerAdmin webmaster@localhost
/etc/apache2/sites-enabled/000-default.conf: ServerAdmin webmaster@localhost
---

# editamos el fichero
vim /etc/apache2/sites-available/000-default.conf y seteamos a: pcjahirdesarrollo@windowsxamp

# editamos y agregamos debajo de <Directory /var/www/> esta directiva:
vim /etc/apache2/apache2.conf
---
<Directory /var/www/html>
Options +Indexes
</Directory>
---
---

Have a nice deploit! Jj Higuera


Pdta:
Recuerda que ahora no se usara localhost para la conexion mysql en file_class_config sino:
---
$aDataFileConfig['aDataDesarrolloConexion'] = array( // Desarrollo NO TOCAR
'host' => "asgard-mysql",
'user' => "root",
'passwd' => "secret",
'dbname' => $aDataFileConfig['aDataLocalConexion']['dbname']
);
---

acceder a apache:
http://localhost:8888/public_html/

acceder a phpmyadmin:
http://localhost:8080/
--

Jahir Jose Higuera E.
+57 320 916 76 60 - Colombia
+34 676 38 48 83 - España
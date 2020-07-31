/*
 *---------------------------------------------------------------
 * habilitar mod_headers en apache2 docker container
 *---------------------------------------------------------------
 *
 * -- comment here --
 *
 */


Primero conectate a un contenedor:
---
docker exec -it -w /var/www/html/public_html/gitlab/projecteditor2019 asgard-php73-apache /bin/bash
---

Despues ejecuta este comando:
With apache2, just run a2enmod headers and then sudo service apache2 restart and it will install the headers module automatically.
habilitar historial comandos bash al conectarse a docker.sh

Primero conectate a un contenedor:
---
docker exec -it -w /var/www/html/public_html/gitlab/projecteditor2019 asgard-php73-apache /bin/bash
---

Después ejecuta este comando:
set -o | grep history
Y listo
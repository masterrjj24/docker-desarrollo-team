desde la terminal en mac, y en tu home, creas o editas este archivo:
Basicamente son alias de comandos ejecutados en terminal

.bash_profile
---export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:/Applications/MAMP/Library/bin"
alias l='ls -lah'
alias server-restart='docker restart asgard-phpmyadmin asgard-mysql asgard-php73-apache'
alias server-start='docker start asgard-phpmyadmin asgard-mysql asgard-php73-apache'
alias server-stop='docker stop asgard-phpmyadmin asgard-mysql asgard-php73-apache'
---


Y así lanzas y detienes rapidamente los contenedores docker.

Enjoy jj
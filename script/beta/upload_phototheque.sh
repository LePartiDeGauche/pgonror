cd /var/srv/lepartidegauche.fr/beta/current
rake alfresco:upload RAILS_ENV=beta
chown lepartidegauche:www-data /srv/lepartidegauche.fr/beta/shared/log/*.log*
chmod 660 /srv/lepartidegauche.fr/beta/shared/log/*.log*
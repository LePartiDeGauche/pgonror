cd /var/srv/lepartidegauche.fr/beta/current
[ ! -e import ] && ln -s /data/archives/www.lepartidegauche.fr import
curl --config /var/srv/lepartidegauche.fr/beta/pggoogle_calendar.conf
rake googlecalendar:import_all RAILS_ENV=beta
rake app:restart RAILS_ENV=beta
chown lepartidegauche:www-data /srv/lepartidegauche.fr/beta/shared/log/*.log*
chmod 660 /srv/lepartidegauche.fr/beta/shared/log/*.log*
cd /srv/lepartidegauche.fr/www/current
[ ! -e import ] && ln -s /data/archives/www.lepartidegauche.fr import
curl --config /srv/lepartidegauche.fr/www/pggoogle_calendar.conf
RAILS_ENV=production bundle exec rake googlecalendar:import_all
RAILS_ENV=production bundle exec rake app:restart
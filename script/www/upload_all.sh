cd /srv/lepartidegauche.fr/www/current
[ ! -e import ] && ln -s /data/archives/www.lepartidegauche.fr import
RAILS_ENV=production bundle exec rake legacy:upload_all
RAILS_ENV=production bundle exec rake app:restart
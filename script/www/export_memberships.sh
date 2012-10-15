cd /srv/lepartidegauche.fr/www/current
RAILS_ENV=production bundle exec rake membership:export_paid
RAILS_ENV=production bundle exec rake membership:export_unpaid
mv tmp/*.csv /data/exports/
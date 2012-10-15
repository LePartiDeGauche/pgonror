cd /var/srv/lepartidegauche.fr/beta/current
[ ! -e import ] && ln -s /data/archives/www.lepartidegauche.fr import
[ ! -e import/pgonror ] && mkdir import/pgonror
rm -R import/pgonror/*
cp -R app import/pgonror
cp -R doc import/pgonror
cp -R script import/pgonror
cp -R spec import/pgonror
cp config.ru import/pgonror
cp Gemfile* import/pgonror
cp Rakefile* import/pgonror
cp README import/pgonror
mkdir import/pgonror/log
mkdir import/pgonror/tmp
mkdir import/pgonror/config
mkdir import/pgonror/config/environments
cp -R config/initializers import/pgonror/config
cp -R config/locales import/pgonror/config
cp config/application.rb import/pgonror/config
cp config/boot.rb import/pgonror/config
cp config/environment.rb import/pgonror/config
cp config/routes.rb import/pgonror/config
echo "development:" > import/pgonror/config/database.yml
echo "  adapter: sqlite3" >> import/pgonror/config/database.yml
echo "  database: db/development.sqlite3" >> import/pgonror/config/database.yml
echo "test:" >> import/pgonror/config/database.yml
echo "  adapter: sqlite3" >> import/pgonror/config/database.yml
echo "  database: db/test.sqlite3" >> import/pgonror/config/database.yml
cp config/environments/development.rb import/pgonror/config/environments
cp config/environments/test.rb import/pgonror/config/environments
mkdir import/pgonror/lib
cp -R lib/paperclip_processors import/pgonror/lib
mkdir import/pgonror/db
cp -R db/migrate import/pgonror/db
cp db/*.rb import/pgonror/db
TODAY=`date +%Y%m%d`
zip -q -r -9 import/pgonror/pgonror.$TODAY.zip import/pgonror
rake sources:upload RAILS_ENV=beta
chown lepartidegauche:www-data /srv/lepartidegauche.fr/beta/shared/log/*.log*
chmod 660 /srv/lepartidegauche.fr/beta/shared/log/*.log*
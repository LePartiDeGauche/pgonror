#!/bin/sh

cd /srv/lepartidegauche.fr/www
rm -f backups/backup.$1.zip
rm current/import
zip -r -9 -q backups/backup.$1.zip current
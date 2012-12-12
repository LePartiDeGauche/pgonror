# Pgonror

Pgonror est le nom informatique du projet de site web www.lepartidegauche.fr développé par les militants du Parti de Gauche.

Le projet adopte la licence publique générale GNU (GNU GENERAL PUBLIC LICENSE) et est disponible gratuitement au téléchargement à partir du site du Parti de Gauche, édité par Le Parti de Gauche, 63 avenue de la République, 75011 Paris.

Le site a été conçu, développé et est maintenu par les adhérents du parti. Les adhérents et militants, ainsi que les sympathisants sont appelés à contribuer à l’évolution du site au travers de la publication de ses sources.

Les sources en exploitation sont disponibles sur le site de partage Github à cette adresse : http://github.com/LePartiDeGauche/pgonror. A partir de cette plateforme, les développeurs peuvent proposer des améliorations ainsi que des corrections, qui pourront être intégrées dans la branche principale de développement ; les visiteurs peuvent également signaler des dysfonctionnements. 

Les sources sont également présentées directement sur le site sous une forme lisible, permettant à chacun de prendre connaissance du logiciel, ainsi que sous la forme d’une archive .zip.


Le site web s’appuie sur la plateforme Ruby on Rails (rubyonrails.org) dans sa version 3.2, disponible sur un grand nombre de systèmes. 

L’installation nécessite un certain nombre de pré-requis : le langage Ruby et RubyGems, enfin Rails (voir http://rubyonrails.org/download ). 

Une fois l’archive téléchargée et décompressée dans un répertoire de travail, la commande `bundle install --without specifics` procède au téléchargement et à l’installation des autres pré-requis nécessaires. 


La commande `rake db:migrate` créé une base de développement (sqlite) et la commande `rails server` permet enfin de lancer l’application. Le projet suit les standard de la plateforme Rails, il est ainsi découpé suivant les répertoires classiques de cette plateforme.

#!/bin/bash
. /etc/profile
. ~/.bash_profile
cd /home/hpd/ieltsbro_production/hpd_ieltsbro
kill -9 $(lsof -t -i:3000)
RAILS_ENV=production rake assets:precompile
bin/rails s -e production
sudo service nginx restart
echo "hpd" >> /home/hpd/test3.txt

kill -9 $(lsof -t -i:3000)
RAILS_ENV=production rake assets:precompile
bin/rails s -e production
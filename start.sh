#! /bin/bash

echo 'Checking ruby dependencies...'
bundle check || bundle install

echo 'Checking yarn dependencies...'
# yarn install --check-files

echo 'Checking database...'
rails db:prepare

echo 'Starting rails server...'

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rails s -p 3000 -b '0.0.0.0'

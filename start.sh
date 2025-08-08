#! /bin/bash

echo 'Checking ruby dependencies...'
bundle check || bundle install

echo 'Checking yarn dependencies...'
yarn install --check-files

echo 'Checking database...'
rails db:prepare

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo 'Starting dart-sass watcher...'
rails dartsass:watch &

echo 'Starting rails server...'
rails server -p 3000 -b '0.0.0.0'

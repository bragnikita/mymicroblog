#!/usr/bin/env bash

[ -f tmp/pids/server.pid ] && rm tmp/pids/server.pid

bundle check || bundle install
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rspec --fail-fast --format d
FROM 'ruby:2.5.0'

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev

ARG RAILS_ENV=docker-test

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

#CMD rails s -b 0.0.0.0 -p 3000
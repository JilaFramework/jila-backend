FROM ruby:2.3.8

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app
RUN apt-get update
RUN apt-get install -y --force-yes nodejs
RUN apt-get install -y --force-yes sqlite3 libsqlite3-dev

COPY Gemfile Gemfile.lock ./

COPY . .
RUN bundle install

ADD ./.profile.d /app/.profile.d
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

CMD rails s -p $PORT

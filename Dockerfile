FROM ruby:2.1.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app
RUN apt-get update
RUN apt-get install -y --force-yes nodejs
RUN apt-get install -y --force-yes sqlite3 libsqlite3-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN rake db:migrate

CMD rails s
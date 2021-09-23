![brakeman analysis](https://github.com/JilaFramework/jila-backend/actions/workflows/brakeman-analysis.yml/badge.svg)
![tests](https://github.com/JilaFramework/jila-backend/actions/workflows/tests.yml/badge.svg)
![lint](https://github.com/JilaFramework/jila-backend/actions/workflows/linter.yml/badge.svg)

## What is this?

[**Jila**](http://jilaframework.github.io) is a framework for building simple language learning apps. This particular repository is for the administrative backend and the API used to communicate with the app.

The **Jila** administration console is built using [Ruby on Rails](http://rubyonrails.org/) and the [ActiveAdmin](http://activeadmin.info/) framework.

## Prerequisites

- Ruby

## Installation

Install Ruby gems
`bundle install`

## Getting Started

### Development
Launch a Rails server however you wish, see their [documentation](http://guides.rubyonrails.org/getting_started.html) if you have any particular questions. The simplest way to launch it would be to run `bundle exec rails s` which will launch a server at 'http://localhost:3000'.

#### Via Docker
Ensure you have docker installed first. Run the `scripts/run_local.sh` which will build and run the backend server using docker. It should be accessible form the same location `http://localhost:3000`.

## Deployment
The backend is a fairly vanilla Ruby on Rails application, so hosting arrangements can be whatever suits the user. The team have been using [Heroku](http://www.heroku.com) for both development/testing and production environments. Asset storage (images and audio) is configured to use [Amazon Simple Storage Service (S3)](http://aws.amazon.com/s3/) for production-like environments, and the local file system for development.

The production environment uses [Paperclip](https://github.com/thoughtbot/paperclip) to upload the assets to S3. For each deployment environment you will have to set environment variables for the S3 bucket name, and the credentials, as outlined in **production.rb**.

## Customisation
The administration console is usable out of the box with no changes. If you do make changes, **please consider submitting a pull request so the community can benefit**.

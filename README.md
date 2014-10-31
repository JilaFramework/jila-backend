# What is this?

**Jila** is a framework for building simple language learning apps. This particular repository is for the administrative backend and the API used to communicate with the app.

# Requirements

The **Jila** backend is written using [Ruby on Rails](http://rubyonrails.org/) and the [ActiveAdmin](http://activeadmin.info/) framework to make it easier to get things up and running. See their documentation if you have any particular questions.

# Hosting

The backend is a fairly vanilla Ruby on Rails application, so hosting arrangements can be whatever suits the user. The team have been using [Heroku](http://www.heroku.com) for both development/testing and production environments. Asset storage (images and audio) is configured to use [Amazon Simple Storage Service (S3)](http://aws.amazon.com/s3/) for production-like environments, and the local file system for development.
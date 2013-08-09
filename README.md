# Diaspora Provisioner

Deploy Diaspora instances to your Heroku account with a web app!

<http://www.getdiaspora.com>

## Setup

### Requirements

You can run a provisioner yourself, if you wish. Here's what you need to
get started:

- An amazon S3 bucket
- A Heroku account
- Redis

You can run this web app locally, if you just want an easy way to set it
up, or you could run it as a simple service for people so they can deploy
their own instances (like we do).

### Procedure

First, clone down this repo and `cd` into it. You'll need to be here for
the duration of the setup procedure.

Install dependencies with [Bundler](http://gembundler.com):

```bash
$ bundle install
```

Set up the db user, actual database for development, and the schema for
the database:

```bash
$ rake db
```

You're ready to run the server! Make sure Redis has started, then run
the following command to get a web server and Resque worker running:

```bash
$ foreman start
```


## TODO

* make this run locally and on heroku itself
* make it more foolproof, maybe make a generator to set up the nessisary files?
* remove a copy of diaspora from this repo
* make it more configurable
* write a more detailed tutorial
* make diaspora run in single process mode by forking a worker inside the heroku process
* allow a user to submit their own heroku api key, so the app could start up an app for you, and then be done with you.

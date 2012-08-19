web: bundle exec rails server -p $PORT
worker: env VVERBOSE=1 QUEUE=* bundle exec rake environment resque:work

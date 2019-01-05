[![Build Status](https://travis-ci.org/yukimura1227/librarian.svg?branch=master)](https://travis-ci.org/yukimura1227/librarian)

# Libralian
amazonでの書籍購入依頼と、購入後の書籍の貸借管理をするためのWebアプリです。


## Setup
bundle install
yarn
bin/rake db:migrate


## Usage

### Required environment variables
```
# google client_id for oauth
GOOGLE_APP_ID
# google secret key for oauth
GOOGLE_APP_SECRET
# webhook url for slack
SLACK_WEBHOOK_URL
# attention name on slack
SLACK_NOTIFY_TO
```

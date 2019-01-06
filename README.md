[![Build Status](https://travis-ci.org/yukimura1227/librarian.svg?branch=master)](https://travis-ci.org/yukimura1227/librarian)
[![Maintainability](https://api.codeclimate.com/v1/badges/93ebeb3317a4dce2fd84/maintainability)](https://codeclimate.com/github/yukimura1227/librarian/maintainability)
[![codecov](https://codecov.io/gh/yukimura1227/librarian/branch/master/graph/badge.svg)](https://codecov.io/gh/yukimura1227/librarian)

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

## Deploy to heroku

```
# heroku first setup
heroku login
heroku git:remote -a libralian
heroku buildpacks:add --index 1 heroku/nodejs # for yarn

# 下記コマンドで、heroku/nodejsとheroku/rubyがこの順で表示されればOK
heroku buildpacks

# rubyがない場合は、以下のコマンドで追加する
# heroku buildpacks:add --index 2 heroku/ruby
```

```
# login heroku user for deploy
heroku login
git push heroku master
heroku run rails db:migrate # if you change migration
```

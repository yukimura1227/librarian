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
# login allow domain. ex) gmail.com,example.com
LOGIN_ALLOW_DOMAIN_CSV
```

## Deploy to heroku

```
# heroku first setup
heroku login
heroku create [any application name]
heroku git:remote -a [specific application name]
heroku buildpacks:add --index 1 heroku/nodejs # for yarn

# 下記コマンドで、heroku/nodejsとheroku/rubyがこの順で表示されればOK
heroku buildpacks

# rubyがない場合は、以下のコマンドで追加する
# heroku buildpacks:add --index 2 heroku/ruby
heroku addons:add heroku-postgresql

heroku config:set 環境変数名=セットしたい値
heroku config:set GOOGLE_APP_ID=aaaa
heroku config:set GOOGLE_APP_SECRET=bbbb
heroku config:set SLACK_WEBHOOK_URL=cccc
heroku config:set SLACK_NOTIFY_TO=dddd
heroku config:add SLACK_ACCESS_TOKEN=xoxp-xxxxxxxxxx
heroku config:set LOGIN_ALLOW_DOMAIN_CSV=eeee
heroku config:add TZ=Asia/Tokyo
heroku config:add APPLICATION_DOMAIN=https://xxxxxxxxx
```
※SLACK_ACCESS_TOKENは、https://api.slack.com/appsからcreate appする必要があり、users.listのAPIを実行できる必要があります。

```
# login heroku user for deploy
heroku login
git push heroku master
heroku run rails db:migrate # if you change migration
```

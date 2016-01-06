# Description:
#   Display a random tweet from alexi or bigp
#
# Dependencies:
#    "twitter" : "https://github.com/desmondmorris/node-twitter",
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN_KEY
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Commands:
#   hubot alexi me - Returns a tweet from alexi
#   hubot bigp me - Returns a tweet from bigp
#
# Author:
#   dl

Twitter = require 'twitter'
_ = require 'underscore'
inspect = require('util').inspect

module.exports = (robot) ->
  auth =
    consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
    consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
    access_token_key: process.env.HUBOT_TWITTER_ACCESS_TOKEN_KEY
    access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

  checkAuth = (msg) ->
    if !auth.consumer_key
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
      return false
    if !auth.consumer_secret
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
      return false
    if !auth.access_token_key
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_KEY environment variable."
      return false
    if !auth.access_token_secret
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return false
    return true

  robot.respond /bigp me/i, (msg) ->
    if checkAuth(msg)
      fetchTweet('patricknlewis', msg)

  robot.respond /alexi me/i, (msg) ->
    if checkAuth(msg)
      fetchTweet('alexiskold', msg)

  fetchTweet = (name, msg) ->
    twit = new Twitter(auth)
    twit.get '/statuses/user_timeline.json', {screen_name: name}, (err, data) ->
      if err
        msg.send "Encountered a problem twitter searching :(", inspect err
      if data?.length
        tweets = _.pluck(data, 'text')
        random = Math.round(Math.random() * (tweets.length - 1))
        msg.send tweets[random]

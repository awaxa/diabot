# Description:
#   gets tweet from a url
#
# Dependencies:
#   "twit": "1.1.13"
#   "underscore": "1.4.4"
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Commands:
#   http[s]://twitter.com/<twitter username>/status/<id> - will pull out the tweet for you
#
# Author:
#   KevinTraver
#   dosman711
#   jjasghar

_ = require "underscore"
Twit = require "twit"
config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

@count_occurences = (str, substr) ->
  regexp = new RegExp(substr, "g")
  result = str.match(regexp)
  (if result then result.length else 0)
  
@max_newlines = 5

module.exports = (robot) ->
  twit = undefined

  robot.hear /http[s]?:\/\/twitter.com\/(.*)/i, (msg) ->
    unless config.consumer_key
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
      return
    unless config.consumer_secret
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
      return
    unless config.access_token
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN environment variable."
      return
    unless config.access_token_secret
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return

    unless twit
      twit = new Twit config

    url = msg.match[1].split("/") 
    name =  url[0]
    id = url[2].toString()

    twit.get "statuses/show/:id",
      {id: id},
      (err, reply) ->
        if err
          return console.log(err)
        newline_count = @count_occurrences(reply.text)
        sentText = reply.text
        if newline_count > @max_newlines and reply.text
          index = sentText.indexOf("/n")
          count = 1
          while index > 1 and count < @max_newlines
            index = sentText.indexOf("/n", index + 1)
            ++count
          sentText = sentText.substring(0, index) + " [truncated]"
        return msg.send _.unescape(sentText) if sentText

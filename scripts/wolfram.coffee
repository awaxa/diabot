# Description:
#   Allows hubot to answer almost any question by asking Wolfram Alpha
#
# Dependencies:
#   "wolfram": "0.2.2"
#
# Configuration:
#   HUBOT_WOLFRAM_APPID - your AppID
#
# Commands:
#   hubot question <question> - Searches Wolfram Alpha for the answer to the question
#   hubot wfa <question> - Searches Wolfram Alpha for the answer to the question
#   hubot nutr[ition] [optional serving size] <food item> - Searches Wolfram Alpha for nutritional value
#
# Notes:
#   This may not work with node 0.6.x
#
# Author:
#   dhorrigan
#   awaxa

Wolfram = require('wolfram').createClient(process.env.HUBOT_WOLFRAM_APPID)

module.exports = (robot) ->
  robot.respond /(question|wfa) (.*)$/i, (msg) ->
    Wolfram.query msg.match[2], (e, result) ->
      if result and result.length > 0
        response = result[1]['subpods'][0]['value']
        response = response.replace /\r?\n|\r/g, '; '
        response = response.replace /\ \|/g, ':'
        msg.send response
      else
        msg.send 'Hmm...not sure'

  robot.respond /nutr(ition)? (.*)$/i, (msg) ->
    Wolfram.query 'nutrition' + msg.match[2], (e, result) ->
      if result and result.length > 0
        response = result[1]['subpods'][0]['value']
        response = response.replace /\r?\n|\r/g, '; '
        response = response.replace /\ \|/g, ':'
        response = response.replace /\s*;\s*/g, ' | '
        response = response.replace RegExp(' : ', 'g'), ' '
        msg.send response
      else
        msg.send 'Hmm... not sure'

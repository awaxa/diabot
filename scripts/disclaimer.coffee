# Description:
#   Do not remind users that we are not doctors.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot disclaimer - Remind users that we are not doctors.
#
# Author:
#   awaxa

module.exports = (robot) ->
  robot.respond /disclaim/i, (msg) ->
    reply = 'fuck you'
    msg.send reply

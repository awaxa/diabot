# Description:
#   Remind users that we are not doctors.
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
    reply = 'Remember that none of us are medical professionals in any way.'
    reply += '  Please consult your physician or healthcare provider when in doubt.'
    msg.send reply

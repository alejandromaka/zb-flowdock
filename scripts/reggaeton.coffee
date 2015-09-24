# Description:
#   reggaeton images
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   dat richi - displays richi image
#   ddl - displays du lait image
#   papi schwab - displays schwab image
#
# Author:
#   alejandro du lait

ddl   = "http://cl.ly/image/1N06400q2O1m"
papi  = "http://cl.ly/image/3q0I2l2Z3w0i"
richi = "http://cl.ly/image/463q46463k0B"
zb    = "http://i.giflike.com/kbJdXYZ.gif"

module.exports = (robot) ->
  robot.hear /^ddl$/i, (msg) ->
    msg.send ddl

  robot.hear /papi schwab/i, (msg) ->
    msg.send papi

  robot.hear /dat richi/i, (msg) ->
    msg.send richi

  robot.hear /dat zb|fu zb/i, (msg) ->
    msg.send zb

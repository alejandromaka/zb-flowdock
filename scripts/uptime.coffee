# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot uptime - Outputs bot uptime
#
# Author:
#   whitman

module.exports = (robot) ->

  start = new Date().getTime()

  robot.respond /uptime/i, (msg) ->
    uptimeMe msg, start, (uptime) ->
      msg.send uptime

numPlural = (num) ->
  if num != 1 then 's' else ''

uptimeMe = (msg, start, cb) ->
  now = new Date().getTime()
  uptime_seconds = Math.floor((now - start) / 1000)
  intervals = {}
  intervals.dia = Math.floor(uptime_seconds / 86400)
  intervals.ora = Math.floor((uptime_seconds % 86400) / 3600)
  intervals.minuto = Math.floor(((uptime_seconds % 86400) % 3600) / 60)
  intervals.segumdo = ((uptime_seconds % 86400) % 3600) % 60

  elements = []
  for own interval, value of intervals
    if value > 0
      elements.push value + ' ' + interval + numPlural(value)

  if elements.length > 1
    last = elements.pop()
    response = elements.join ', '
    response += ' and ' + last
  else
    response = elements.join ', '

  cb 'me desperte hase ' + response

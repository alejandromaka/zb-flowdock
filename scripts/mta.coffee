# Description:
#   See the status of NYC subways
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot mta me <train> - the status of a nyc subway line
#
# Author:
#   jgv

xml2js = require('xml2js')

module.exports = (robot) ->
  robot.respond /mta\s*(?:me)?\s*(\w+)?/i, (msg) ->
    mtaMe msg

mtaMe = (msg) ->
  msg.http('http://web.mta.info/status/serviceStatus.txt')
  .get() (err, res, body) ->
    if err
      throw err
    parser = new xml2js.Parser({'explicitRoot' : 'service', 'normalize' : 'false' })
    parser.parseString body, (err, res) ->
      if err
        throw err
      re = new RegExp(msg.match[1], 'gi')
      if msg.match[1].length is 1 or msg.match[1].toUpperCase() is 'SIR'
        for k in res.service.subway[0].line
          str = k.name[0]
          if str.match(re)
            if k.status[0] == 'GOOD SERVICE'
              msg.send 'el ' + str + ' tren ta too bien'
            else if k.status[0] == 'PLANNED WORK'
              msg.send 'ey cuidao, el ' + str + ' tren tiene trabajo gracias a dios.'
            else
              msg.send 'el ' + str + ' tren se metio con las drogas y cosas. resa por su familia.'
      else
        msg.send 'ah?! que?! que tren es ese?'

# Description:
#   None
#
# Dependencies:
#   "jsdom": "0.2.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot whatis <term> - search the term on urbandictionary.com and get a random popular definition for the term.
#
# Author:
#   Kevin Qiu
#
# FIXME merge with urban.coffee

jsdom = require('jsdom').jsdom

module.exports = (robot) ->
  robot.respond /whatis (.+)$/i, (msg) ->
    link = 'http://www.urbandictionary.com/define.php?term=' + (encodeURIComponent msg.match[1])
    fetchTerm = (link) ->
      msg
        .http(link)
        .get() (err, res, body) ->
          if res.statusCode == 302
            fetchTerm(res.headers.location)
          else
            window = (jsdom body, null,
              features :
                FetchExternalResources : false
                ProcessExternalResources : false
                MutationEvents : false
                QuerySelector : false
            ).createWindow()

            $ = require('jquery').create(window)

            definitions = []

            $(".meaning").each (idx, item) ->
              definitions.push $(item).text()

            msgText = if definitions.length==0 then "no ta bien" else (msg.random definitions)
            msg.send msgText.replace /^\s+|\s+$/g, ""

    fetchTerm(link)
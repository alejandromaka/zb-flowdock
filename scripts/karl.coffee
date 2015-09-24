# Description:
#   Retrieves karl pilkington quotes
#
# Dependencies:
#   "jsdom": "0.2.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot karl me - fetches an awesome karl pilkington quote
#
# Author:
#   du lait

jsdom = require('jsdom').jsdom

module.exports = (robot) ->
  robot.respond /karl$/i, (msg) ->
    msg
      .http('http://www.pilkipedia.co.uk/wiki/index.php?title=Karl_Pilkington_Quotes_By_Topic')
      .get() (err, res, body) ->
        window = (jsdom body, null,
          features :
            FetchExternalResources : false
            ProcessExternalResources : false
            MutationEvents : false
            QuerySelector : false
        ).createWindow()

        $ = require('jquery').create(window)

        quotes = []

        $("p").each (idx, item) ->
          quotes.push $(item).clone().children().remove().end().text()

        msgText = msg.random quotes
        msg.send msgText.replace /\s*-\s*$/g, ""
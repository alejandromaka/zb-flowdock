module.exports = (robot) ->
   cronJob = require('cron').CronJob
   new cronJob('0 */10 * * * *', pingBotUrl(robot), null, true)

 pingBotUrl = (robot) ->
   -> robot.http("#{process.env.HEROKU_URL}/hubot/ping").get() (err, res, body) ->
           console.log("It's currently #{res.headers.date}")
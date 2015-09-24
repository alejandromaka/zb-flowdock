# Description:
#   Keep a variaty of logs
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot logs - shows all logs stored
#   hubot <name>log last <number> - show last number of logs 
#   hubot <name>log <message> - add a new log
#   hubot <name>log #<number> - get entry at number
#   hubot <name>log random - get random entry
#
# Author
#   rix501

module.exports = (robot) ->
  logs = new Logs robot

  robot.respond /([a-z]+)log(?: last(?: (\d+)){0,1}){0,1}$/i, (msg) ->
    logs.getLast msg.match[1], msg.match[2], (message) ->
      msg.send "#{message}"

  robot.respond /logs$/i, (msg) ->
    logs.allLogs (message) ->
      msg.send "#{message}"

  robot.respond /([a-z]+)log random$/i, (msg) ->
    logs.random msg.match[1], (message) ->
      msg.send "#{message}"

  robot.respond /([a-z]+)log #(\d+)$/i, (msg) ->
    logs.find msg.match[1], msg.match[2], (message) ->
      msg.send "#{message}"

  robot.respond /([a-z]+)log ([^#]{1}.+)/i, (msg) ->
    return if msg.match[2] is 'random' or /last(?: \d+){0,1}/.test(msg.match[2])
    logs.add msg.match[1], msg.match[2], (message) ->
      msg.send "#{message}"

# Classes

class Logs
  constructor: (robot) ->
    @_logs = {}

    robot.brain.on 'loaded', =>
      if not robot.brain.data.logs
        robot.brain.data.logs = {}
      
      @_logs = robot.brain.data.logs        

  add: (logName, message, callback) ->
    unless @_logs.hasOwnProperty logName
      @_logs[logName] = []

    log = @_logs[logName]

    log.push message

    callback "Log ##{log.length} added to #{logName}log"

  random: (logName, callback) ->
    unless @_logs.hasOwnProperty logName
      callback "#{logName}log doesn't exist"
      return

    log = @_logs[logName]

    number = Math.floor(Math.random()*log.length)

    callback log[number]      

  find: (logName, index, callback) ->
    unless @_logs.hasOwnProperty logName
      callback "#{logName}log doesn't exist"
      return

    index = 1 if index == 0

    log = @_logs[logName]

    index = parseInt(index, 10) - 1

    if index >= log.length
      callback "Entry ##{index+1} doesn't exist in #{logName}log"
      return

    callback log[index]  

  allLogs: (callback) ->
    unless Object.keys(@_logs).length > 0
      callback "No logs exist"
      return

    lines = for own name, log of @_logs
      entStr = if log.length == 1 then 'entry' else 'entries'
      "#{name}log with #{log.length} #{entStr} \n"

    lastLine = lines[lines.length-1]
    lastLine = lastLine.substring(0, lines.length-1)

    callback lines.join('')

  getLast: (logName, n = 10, callback) ->
    unless @_logs.hasOwnProperty logName
      callback "#{logName}log doesn't exist"
      return

    log = @_logs[logName]

    n = log.length if log.length < n
    results = log.slice(log.length-n, log.length)
    lines = for message,i in results
      "#{message}#{if i < n-1 then '\n' else ''}"
    callback lines.join('')
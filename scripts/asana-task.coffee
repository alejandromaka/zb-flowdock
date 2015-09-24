# Description:
#   Get description for asana task
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   asana link - show description of task and project
#
# Author
#   rix501

module.exports = (robot) ->
  asana = new Asana robot

  robot.hear /https:\/\/app\.asana\.com\/0\/(\d+)\/(\d+)$/i, (msg) ->
    asana.setHTTP msg.http

    asana.getInfo msg.match[1], msg.match[2], (info)->
      msg.send info

# Classes

class Asana
  constructor: (robot) ->
    @robot = robot
    @apiKey = process.env.ASANA_API_KEY

  setHTTP: (http) ->
    @robot.http = http unless @robot.http?

  getUrl: (type, id) ->
    "https://app.asana.com/api/1.0/#{type}/#{id}"

  getAuth: ->
    'Basic ' + new Buffer("#{@apiKey}:").toString('base64')

  getProjectInfo: (projectId, cb) ->
    @robot.http(@getUrl('projects', projectId))
      .header('Authorization', @getAuth())
      .get() (err, res, body) =>

        cb JSON.parse(body)

  getTaskInfo: (taskId, cb) ->
    @robot.http(@getUrl('tasks', taskId))
      .header('Authorization', @getAuth())
      .get() (err, res, body) =>

        cb JSON.parse(body)

  getInfo: (projectId, taskId, cb) ->
    info = {}

    @getProjectInfo projectId, (body) =>

      info.project = if body.errors? then null else body.data

      @getTaskInfo taskId, (body) =>

        info.task = if body.errors? then null else body.data

        msg = ''

        if info.project?
          msg = "Project: #{info.project.name}"

        console.log info.task

        if info.task?

          msg += "\nTask: #{info.task.name}"

          if info.task.notes.length > 0
            msg += "\nNotes: #{info.task.notes}"

          if info.task.assignee?
            msg += "\nAssigned to: #{info.task.assignee.name}"
          else
            msg += '\nUnassigned'

        cb msg

# Description:
#   Know name day in No Idea bar
#
# Dependencies:
#  "cheerio": "0.12.0"
#  "moment": "2.0.0"
#
# Configuration:
#
# Commands:
#   hubot no idea - show name of the current day
#   hubot no idea <name> - show last day of name
#
# Author
#   rix501

cheerio = require 'cheerio'
moment = require 'moment'

module.exports = (robot) ->
  bar = new NoIdea robot

  robot.respond /no idea$/i, (msg) ->
    bar.getTodaysName (name)->
      msg.send name

  robot.respond /no idea ([a-z]{3,15})$/i, (msg) ->
    bar.findName null, msg.match[1].toLowerCase(), (date)->
      msg.send date

# Classes

class NoIdea
  constructor: (robot) ->
    @robot = robot 
    @today = moment()

    @months = {}

    robot.brain.on 'loaded', =>
      if not robot.brain.data.noIdeaMonths
        robot.brain.data.noIdeaMonths = {}
      
      @months = robot.brain.data.noIdeaMonths   

  fetch: (date, cb) ->
    # February 2011 is the first month with names
    if date.format('M') is '1' and date.format('YYYY') is '2011'
      cb null
      return

    if @months["#{date.format('YYYY')}-#{date.format('M')}"]?
      cb @months["#{date.format('YYYY')}-#{date.format('M')}"]
      return

    params = 
      p: 11
      date: 'set'
      month_name: date.format('MMMM')
      month: date.format('M')
      year: date.format('YYYY')

    @robot.http('http://www.noideabar.com/')
      .query(params)
      .get() (err, res, body) => 

        $ = cheerio.load(body)

        names = []

        $('.event center b').each -> names.push $(@).text().toLowerCase()

        @months["#{date.format('YYYY')}-#{date.format('M')}"] = names

        cb names

  getTodaysName: (cb) ->
    @fetch @today, (month) =>
      name = month[@today.date() - 1]
      cb if name is '[closed]'
        'No Idea is closed today :('
      else
        name

  findName: (day, name, cb) ->
    day ?= moment(@today)

    @fetch day, (month) =>
      date = null

      unless month?
        @showName(name, date,cb)
        return

      month.forEach (elem, index)->
        if elem.toLowerCase() is name.toLowerCase()
          date = moment(day).date(index + 1)

      if date?
        @showName(name, date,cb)
      else
        @findName day.month(day.month() - 1), name, cb

  showName: (name, date, cb) =>
      result = if date? 
        if date.isBefore(@today)
          "It was on #{date.format('dddd, MMMM Do YYYY')} (you missed it!)"
        else
          "It's on: #{date.format('dddd, MMMM Do YYYY')}"
      else
        "No #{name} yet"

      cb result
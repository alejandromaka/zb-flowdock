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
#   hubot doge me - fetches a pic from supershibe subreddit
#
# Author:
#   du lait

module.exports = (robot) ->
  robot.respond /doge me/i, (msg) ->
    reddit msg

reddit = (msg) ->
  url = "http://www.reddit.com/r/supershibe/top.json"
  msg
    .http(url)
      .get() (err, res, body) ->

        posts = JSON.parse(body)

        post = getPost(posts)

        msg.send post.url

getPost = (posts) ->
  random = Math.round(Math.random() * posts.data.children.length)
  posts.data.children[random]?.data

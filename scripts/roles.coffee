# Description:
#   Assign roles to people you're chatting with
#
# Commands:
#   hubot <user> is a badass guitarist - assign a role to a user
#   hubot <user> is not a badass guitarist - remove a role from a user
#   hubot who is <user> - see what roles a user has
#
# Examples:
#   hubot holman is an ego surfer
#   hubot holman is not an ego surfer

module.exports = (robot) ->

  if process.env.HUBOT_AUTH_ADMIN?
    robot.logger.warning 'The HUBOT_AUTH_ADMIN environment variable is set not going to load roles.coffee, you should delete it'
    return

  getAmbiguousUserText = (users) ->
    "AH? hay no se que aser. hay #{users.length} persona con ese nombre: #{(user.name for user in users).join(", ")}"

  robot.respond /who is @?([\w .\-]+)\?*$/i, (msg) ->
    joiner = ', '
    name = msg.match[1].trim()

    if name is "you"
      msg.send "el cantante del amor"
    else if name is robot.name
      msg.send "el cantante del amor"
    else
      users = robot.brain.usersForFuzzyName(name)
      if users.length is 1
        user = users[0]
        user.roles = user.roles or [ ]
        if user.roles.length > 0
          if user.roles.join('').search(',') > -1
            joiner = '; '
          msg.send "#{name} es #{user.roles.join(joiner)}."
        else
          msg.send "#{name} es nadie pa mi."
      else if users.length > 1
        msg.send getAmbiguousUserText users
      else
        msg.send "#{name}? quien es ese?"

  robot.respond /@?([\w .\-_]+) is (["'\w: \-_]+)[.!]*$/i, (msg) ->
    name    = msg.match[1].trim()
    newRole = msg.match[2].trim()

    unless name in ['', 'who', 'what', 'where', 'when', 'why']
      unless newRole.match(/^not\s+/i)
        users = robot.brain.usersForFuzzyName(name)
        if users.length is 1
          user = users[0]
          user.roles = user.roles or [ ]

          if newRole in user.roles
            msg.send "mijo ya se"
          else
            user.roles.push(newRole)
            if name.toLowerCase() is robot.name.toLowerCase()
              msg.send "Okey, yo soy #{newRole}."
            else
              msg.send "Okey, #{name} es #{newRole}."
        else if users.length > 1
          msg.send getAmbiguousUserText users
        else
          msg.send "no se naa de #{name}."

  robot.respond /@?([\w .\-_]+) is not (["'\w: \-_]+)[.!]*$/i, (msg) ->
    name    = msg.match[1].trim()
    newRole = msg.match[2].trim()

    unless name in ['', 'who', 'what', 'where', 'when', 'why']
      users = robot.brain.usersForFuzzyName(name)
      if users.length is 1
        user = users[0]
        user.roles = user.roles or [ ]

        if newRole not in user.roles
          msg.send "ya se."
        else
          user.roles = (role for role in user.roles when role isnt newRole)
          msg.send "Okey, #{name} ya no es #{newRole}."
      else if users.length > 1
        msg.send getAmbiguousUserText users
      else
        msg.send "no se naa de #{name}."

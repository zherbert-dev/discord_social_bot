require_relative 'giphy_logic'
require_relative '../modules/response'

def welcome_new_member(event)
    username = get_username_from_message_mentions
    unless username.empty?
        message = Response::WELCOME
        event.channel.send_message(message)
    end
end

def validate_command_and_respond(event, command)
    case command.downcase
    when '!help'
        message = Response::HELP
    when '!twitch'
        message = Response::TWITCH
    when '!github'
        message = Response::GITHUB
    when '!wisdom'
        message = Response::UNDER_DEVELOPMENT
    when '!rolld20'
        value = roll_d_twenty
        message = Response::ROLL + value
    when '!randomgif'
        message = Response::UNDER_DEVELOPMENT
    when '!pizza'
        message = Response::PIZZA_VIDEO
    when '!clear'
        message = Response::CLEAR
    else
        message = Response::UNKNOWN_COMMAND
    end

    respond_to_command(event, message)
end

def respond_to_command(event, message)
    event.channel.send_message message
end

def roll_d_twenty
    rand(1..20)
end

def get_username_from_message_mentions (event)
    event.message.mentions[0].username || nil
end
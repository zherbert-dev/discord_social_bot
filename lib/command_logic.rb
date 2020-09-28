require_relative '../modules/response'
require_relative 'twitter_logic'

def welcome_new_member(event)
    unless get_username_from_message_mentions.nil?
        begin
            event.channel.send_message Response::WELCOME         
        rescue => e
            logger.error e.message
            logger.error e.backtrace
        end
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
    when '!rolld20'
        message = Response::ROLL + rolld20
    when '!pizza'
        message = Response::PIZZA_VIDEO
    when '!clear'
        message = Response::CLEAR
    else
        message = Response::UNKNOWN_COMMAND
    end

    if command.downcase == '!tweet'
        twitter_client = get_twitter_client
        message = event.message.content
        message.slice!('!tweet ')
        create_twitter_post(twitter_client, message)
    else
        respond_to_command(event, message)
    end
end

def respond_to_command(event, message)
    begin
        event.channel.send_message message
    rescue => e
        logger.error e.message
        logger.error e.backtrace
    end
end

def roll_d_twenty
    rand(1..20)
end

def get_username_from_message_mentions (event)
    event.message.mentions[0].username || nil
end
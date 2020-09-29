# frozen_string_literal: true

module DiscordSocialBot
  module CommandLogic
    def welcome_new_member(event)
      return if get_username_from_message_mentions.nil?

      begin
        event.channel.send_message Response::WELCOME
      rescue StandardError => e
        logger.error e.message
        logger.error e.backtrace
      end
    end

    def validate_command_and_respond(event, command)
      cmd = command.downcase
      message = case cmd
                when '!help'
                  Response::HELP
                when '!twitch'
                  Response::TWITCH
                when '!github'
                  Response::GITHUB
                when '!rolld20'
                  Response::ROLL + roll_d_twenty
                when '!pizza'
                  Response::PIZZA_VIDEO
                when '!clear'
                  Response::CLEAR
                else
                  Response::UNKNOWN_COMMAND
                end
    
      if command.downcase == '!live'
        if event.server.owner == event.message.author
          twitter_client = twitter_client
          message = event.message.content
          message.slice!('!live ')
          create_twitter_post(twitter_client, message)
        else
          message = Response::NOT_AUTHORIZED
          respond_to_command(event, message)
        end
      else
        respond_to_command(event, message)
      end
    end
    
    def respond_to_command(event, message)
      event.channel.send_message message
    end
    
    def roll_d_twenty
      rand(1..20).to_s
    end
    
    def get_username_from_message_mentions(event)
      event.message.mentions[0].username || nil
    end
  end
end

#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'twitter_logic.rb'

module CommandLogic
  include TwitterLogic

  module Response
    CLEAR = "Silly goose, this isn't a terminal! Get back to coding ;)"
    GITHUB = 'Find ThiccKrust on Github at https://github.com/zherbert-dev'
    HELP = "Available commands:\n
              !help -- returns a list of available commands\n
              !going-live -- post a tweet to your configured twitter account (server owner only)\n
              !twitch -- returns ThiccKrust's twitch account URL\n
              !github -- return ThiccKrust's github page\n
              !rolld20 -- roll a D20 die"
    PIZZA_VIDEO = 'https://youtu.be/CJEoASUMZbI'
    ROLL = 'You rolled a : '
    TWITCH = 'Find ThiccKrust on Twitch at https://twitch.tv/thicc_krust'
    UNDER_DEVELOPMENT = 'This feature is currently under development.'
    UNKNOWN_COMMAND = "The command you have chosen is unknown to this bot.
                        \nPlease type '!help' to get a list of available commands."
    WELCOME = 'Welcome to Pizza Planet, glad to have you!! Grab yourself a hot slice and hangout for a while!'
    NOT_AUTHORIZED = 'WOAH THERE BUDDY! You are NOT AUTHORIZED to use this command!'
  end

  def self.welcome_new_member(event)
    return if get_username_from_message_mentions.nil?

    begin
      event.channel.send_message Response::WELCOME
    rescue StandardError => e
      logger.error e.message
      logger.error e.backtrace
    end
  end

  def self.validate_command_and_respond(event, command)
    cmd = command.downcase
    message = command_response(command.downcase) unless cmd == '!live'

    if cmd == '!live'
      if event.server.owner == event.message.author
        send_tweet(event)
      else
        message = Response::NOT_AUTHORIZED
      end
    end
    respond_to_command(event, message)
  end

  def self.respond_to_command(event, message)
    event.channel.send_message message
  end

  def self.roll_d_twenty
    rand(1..20).to_s
  end

  def self.get_username_from_message_mentions(event)
    event.message.mentions[0].username || nil
  end

  def self.send_tweet(event)
    twitter_client = TwitterLogic.twitter_client
    message = event.message.content
    message.slice!('!live ')
    TwitterLogic.create_twitter_post(twitter_client, message)
  end

  def self.command_response(command)
    case command
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
  end
end

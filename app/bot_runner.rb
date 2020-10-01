# frozen_string_literal: true

# Modules
require '/modules/command_logic.rb'
require '/modules/level_up_logic.rb'

# Gems
require 'discordrb'
require 'redis'
require 'logger'
require 'yaml'
require 'twitter'

class SocialDiscordBot
  # Include Modules
  include CommandLogic
  include LevelUpLogic

  # Load config from file
  begin
    CONFIG = YAML.load_file('config.yaml')
  rescue StandardError => e
    puts e
    puts 'Config file not found, this is fatal!\n Please run setup.rb to configure application.'
    exit
  end

  log = Logger.new('logs/log.txt', 'weekly')
  log.level = Logger::WARN

  bot = Discordrb::Bot.new token: CONFIG['discord_bot_token'], ignore_bots: true
  redis_conn = Redis.new

  # Monitor main channel for a new user to join and respond with a welcome message
  bot.member_join do |event|
    CommandLogic.welcome_new_member(event)
  end

  # Bot Commands and Response
  # Commands will be messages that start with '!'
  bot.message(start_with: '!') do |event|
    command = event.message.content.split(' ')[0]
    CommandLogic.validate_command_and_respond(event, command)
    LevelUpLogic.add_points(redis_conn, event)
  end

  bot.run
end

SocialDiscordBot.new

# frozen_string_literal: true

# Modules
require_relative 'modules/command_logic.rb'
require_relative 'modules/level_up_logic.rb'

# Gems
require 'discordrb'
require 'redis'
require 'logger'
require 'json'
require 'twitter'

class SocialDiscordBot
  # Include Modules
  include CommandLogic
  include LevelUpLogic

  # Load config from file
  begin
    CONFIG = JSON.load_file('app/config', 'config.json')
  rescue StandardError => e
    puts "ERROR: #{e}"
    puts "Config file not found, this is fatal!\n Please run scripts/setup.rb to configure application."
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

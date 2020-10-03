# frozen_string_literal: true

# Modules/Classes
require_relative 'modules/level_up_logic.rb'
require_relative 'models/command.rb'

# Gems
require 'discordrb'
require 'redis'
require 'logger'
require 'json'
require 'twitter'

class SocialDiscordBot
  # Include Modules
  include LevelUpLogic

  # Load config from file
  begin
    config_file = File.read('app/config/config.json')
    CONFIG = JSON.parse(config_file)
  rescue StandardError => e
    puts "ERROR: #{e}"
    puts "Config file not found, this is fatal!\n Please run scripts/setup.rb to configure application."
    exit
  end

  log = Logger.new('app/logs/log.txt', 'weekly')
  log.level = Logger::WARN

  bot = Discordrb::Bot.new token: CONFIG['bot_settings']['discord_bot_token'], ignore_bots: true
  redis_conn = Redis.new
  
  ## create commands from config
  CONFIG['commands'].each do |c|
    cmd = Command.new(c['name'], c['description'], c['response'])
  end

  # Bot Commands and Response
  # Commands will be messages that start with '!'
  bot.message(start_with: '!') do |event|
    entered_command = event.message.content.split(' ')[0]
    Command.validate_and_respond(entered_command, event)
    LevelUpLogic.add_points(redis_conn, event)
  end

  bot.run
end

SocialDiscordBot.new

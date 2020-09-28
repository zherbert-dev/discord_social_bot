require_relative 'lib/command_logic'
require_relative 'lib/level_up_logic'

require 'discordrb'
require 'redis'
require 'logger'
require 'yaml'

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
rc = Redis.new

# Monitor main channel for a new user to join and respond with a welcome message
bot.member_join do |event|
    welcome_new_member(event)
end

# Bot Commands and Response
# Commands will be messages that start with '!'
bot.message(start_with:'!') do |event|
    command = event.message.content.split(' ')[0]
    validate_command_and_respond(event, command)
    add_points(rc, event)
end

bot.run

require_relative 'lib/command_logic'
require_relative 'lib/level_up_logic'
require_relative 'lib/twitter_logic'

require 'dotenv'
require 'discordrb'
require 'redis'
require 'logger'
require 'yaml'

# Load config from file
begin
    CONFIG = YAML.load_file('config.yaml')
rescue StandardError => e
    puts e
    puts 'Config file not found, this is fatal, running setup.'
    `ruby bot_setup.rb`
    exit
end

Dotenv.load

log = Logger.new('logs/log.txt', 'weekly')
log.level = Logger::WARN

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN'], ignore_bots: true
rc = Redis.new

# Monitor a given channel for a message that starts with 'Going live!' and send 
# the message contents to the configured Twitter account
bot.message({in: ENV["ANNOUNCEMENTS_CHANNEL_ID"].to_i, start_with: 'Going live!'}) do |event|
    twitter_client = get_twitter_client
    create_twitter_post(twitter_client, event)
end

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

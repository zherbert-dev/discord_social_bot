require_relative 'lib/command_logic'
require_relative 'lib/level_up_logic'
require_relative 'lib/twitter_logic'

require 'dotenv'
require 'discordrb'
require 'redis'

Dotenv.load

bot = Discordrb::Bot.new token: "NzU4MzI0NzA2NzUxMDIxMDU2.X2tS6w.-jrMqDxJ4smNCRxMCDRNgJIRO-I", ignore_bots: true
redis_connection = Redis.new

# Monitor a given channel for a message that starts with 'Going live!' and send 
# the message contents to the configured Twitter account
# bot.message({in: ENV['ANNOUNCEMENTS_CHANNEL_ID'], start_with: 'Going live!'}) do |event|
#     twitter_client = set_twitter_client
#     create_twitter_post(twitter_client, event)
# end

# bot.message do |event|
#     add_points(r, event)
# end

## Monitor main channel for a new user to join and respond with a welcome message
# bot.member_join do |event|
#     welcome_new_member(event)
# end

# Bot Commands and Response
# Commands will be messages that start with '!'
bot.message(start_with:'!') do |event|
    command = event.message.content.split(' ')[0]
    validate_command_and_respond(event, command)
    add_points(r, event)
end

bot.run

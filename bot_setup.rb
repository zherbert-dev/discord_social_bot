# frozen_string_literal: true

class BotSetup
  def initialize
    begin
      require 'yaml'
    rescue LoadError
      puts 'YAML not found! Is your ruby ok?'
      exit
    end

    @config = YAML.load_file('config.yaml')
    exit if @config == false
  end

  def welcome(skip = false)
    return if skip

    puts "Welcome to Discord Social Bot Setup\nThis really simple GUI will guide you in setting up the bot by yourself!
          \nPress enter to get started"
    gets

    puts "What would you like to do? (type number then press enter)\n[1] - Configure the bot\n[2] - Exit!"
    input = gets.chomp

    config if input == '1'
    exit
  end

  def config
    puts "Time to configure the bot.\nWhat would you like to configure?\n[1] - Bot information (REQUIRED)
          \n[2] - API Keys\n[3] - Main Menu"

    configure_bot_settings if input == gets.chomp
    save_and_return_to_config_menu

    configureapi_settings if input == gets.chomp
    save_and_return_to_config_menu

    welcome
  end

  def save
    File.open('config.yaml', 'w') { |f| f.write @config.to_yaml }
  rescue StandardError => e
    puts 'uh oh, there was an error saving your config. Report the following error to herberzt-dev on github'
    puts e
  end

  def check_if_config_exists
    return if File.exist?('config.yaml')

    puts 'No config file! Creating one now..'
    File.new('config.yaml', 'w+')
    exconfig = YAML.load_file('config.example.yaml')
    File.open('config.yaml', 'w') { |f| f.write exconfig.to_yaml }
  end

  def configure_bot_settings
    puts 'Please enter your discord bot token.'
    @config['discord_bot_token'] = gets.chomp

    puts 'Enable twitter posting, y/n?'
    @config['enable_twitter'] = gets.chomp.downcase == 'y'

    return unless @config['enable_twitter']

    puts 'Channel ID to tweet from'
    @config['channel_id_to_tweet_from'] = gets.chomp
    save_and_return_to_config_menu
  end

  def configure_api_settings
    puts 'Twitter Consumer Key'
    @config['twitter_consumer_key'] = gets.chomp

    puts 'Twitter Consumer Secret'
    @config['twitter_consumer_secret'] = gets.chomp

    puts 'Twitter Access Token'
    @config['twitter_access_token'] = gets.chomp

    puts 'Twitter Private Access Token'
    @config['twitter_access_token_secret'] = gets.chomp
  end

  def save_and_return_to_config_menu
    save
    config
  end
end

menu = BotSetup.new
menu.welcome

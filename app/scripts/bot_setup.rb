# frozen_string_literal: true

class BotSetup
  def initialize
    begin
      require 'json'
    rescue LoadError
      puts 'JSON not found! Is your ruby ok?'
      exit
    end

    begin
      check_if_config_exists
      config_file = File.read('app/config/config.json')
      @config = JSON.parse(config_file)
    rescue
      @config = {}
    end

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
    puts "Welcome to the configuration menu.\nWhat would you like to configure?"
    puts '[1] - Bot information (REQUIRED)'
    puts '[2] - API Keys'
    puts '[3] - Commands'
    puts '[4] - Main Menu'

    option = gets.chomp
    
    if option == '1'
      configure_bot_settings
      save_and_return_to_config_menu
    elsif option == '2'
      configure_api_settings
      save_and_return_to_config_menu
    elsif option == '3'
      configure_commands
      save_and_return_to_config_menu
    end

    welcome
  end

  def save
    File.open('app/config/config.json', 'w') { |f| f.write @config.to_json }
  rescue StandardError => e
    puts 'uh oh, there was an error saving your config. Report the following error to herberzt-dev on github'
    puts e
  end

  def check_if_config_exists
    return if File.exist?('app/config/config.json')

    puts 'No config file! Creating one now..'
    File.new('app/config/config.json', 'w+')
    config_file = File.read('app/config/config.json')
    exconfig_file = File.read('app/config/config.example.json')
    exconfig = JSON.parse(exconfig_file)
    File.open('app/config/config.json', 'w') { |f| f.write exconfig.to_json }
  end

  def configure_bot_settings
    puts 'Please enter your discord bot token.'
    @config['bot_settings']['discord_bot_token'] = gets.chomp

    puts 'Enable twitter posting, y/n?'
    @config['bot_settings']['enable_twitter'] = gets.chomp.downcase == 'y'
  end

  def configure_api_settings
    puts 'Twitter Consumer Key'
    @config['api_settings']['twitter']['twitter_consumer_key'] = gets.chomp

    puts 'Twitter Consumer Secret'
    @config['api_settings']['twitter']['twitter_consumer_secret'] = gets.chomp

    puts 'Twitter Access Token'
    @config['api_settings']['twitter']['twitter_access_token'] = gets.chomp

    puts 'Twitter Private Access Token'
    @config['api_settings']['twitter']['twitter_access_token_secret'] = gets.chomp
  end

  def configure_commands
    cmd_hash = {}

    puts 'Enter command name'
    cmd_hash['name'] = gets.chomp

    puts 'Enter command description'
    cmd_hash['description'] = gets.chomp

    puts 'Enter command response'
    cmd_hash['response'] = gets.chomp

    @config['commands'].push(cmd_hash)
    save

    puts 'Add another command? y/n'
    gets.chomp == 'y' ? configure_commands : config
  end

  def save_and_return_to_config_menu
    save
    config
  end
end

menu = BotSetup.new
menu.welcome

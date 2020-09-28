class BotSetup
    def initialize
        begin
            require 'yaml'
        rescue LoadError
            puts 'YAML not found! Is your ruby ok?'
            exit
        end
        
        unless File.exist?('config.yaml')
            puts 'No config file! Creating one now..'
            File.new('config.yaml', 'w+')
            #exconfig = YAML.load_file('config.example.yaml')
            #File.open('config.yaml', 'w') { |f| f.write exconfig.to_yaml }
        end
        
        @config = YAML.load_file('config.yaml')
        exit if @config == false
    end

    def welcome(skip = false)
        puts "inside welcome"
        unless skip
            puts 'Welcome to Discord Social Bot Setup'
            puts 'This really simple GUI will guide you in setting up the bot by yourself!'
            puts 'Press enter to get started'
            gets

            puts 'What would you like to do? (type number then press enter)'
            puts '[1] - Configure the bot'
            puts '[2] - Exit!'
            input = gets.chomp
        
            config if input == '1'
            exit
        end
    end

    def config
        puts 'Time to configure the bot.'

        puts 'What would you like to configure?'
        puts '[1] - Bot information (REQUIRED)'
        puts '[2] - API Keys'
        puts '[3] - Bot Commands'
        puts '[4] - Main Menu'
        input = gets.chomp

        configure('bot') if input == '1'
        configure('api') if input == '2'
        configure('commands') if input == '3'

        welcome
    end

    def configure(section)
        if section == 'bot'
            puts 'Please enter your discord bot token.'
            @config['discord_bot_token'] = gets.chomp

            puts 'Enable twitter posting, y/n?'
            resp = gets.chomp.downcase
            resp == 'y' ? @config['enable_twitter'] = true : @config['enable_twitter'] = false
            
            puts 'It turns out you\'re done configuring bot settings!'
            save
            config
        end
    
        if section == 'api'
            if @config['enable_twitter']
                puts 'Twitter Consumer Key'
                @config['twitter_consumer_key'] = gets.chomp

                puts 'Twitter Consumer Secret'
                @config['twitter_consumer_Secret'] = gets.chomp

                puts 'Twitter Access Token'
                @config['twitter_access_token'] = gets.chomp

                puts 'Twitter Private Access Token'
                @config['twitter_private_access_token'] = gets.chomp

                puts 'It turns out you\'re done configuring API settings!'
                save
                config
            end
        end

        if section == 'commands'
            while true
                index = 1
                puts 'Enter name of command'
                command_name = gets.chomp
                @config["commands"]["command_#{index}"]["name"]["#{name}"]
                puts 'Enter command description'
                command_description = gets.chomp
                @config["commands"]["command_#{index}"]["description"] = command_description
                puts 'Enter command response'
                command_response = gets.chomp
                @config["commands"]["command_#{index}"]["response"] = command_response

                puts "Add another command?"
                puts "y/n"

                if gets.chomp == 'n'
                    false
                end
            end
            save
            config
        end
    end
    
    def save
        File.open('config.yaml', 'w') { |f| f.write @config.to_yaml }
        rescue StandardError => e
        puts 'uh oh, there was an error saving your config. Report the following error to herberzt-dev on github'
        puts e
    end
end

menu = BotSetup.new
menu.welcome

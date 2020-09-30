[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

# discord_social_bot
### About
* Features:
  * Server owner can post to twitter via !live command.
    * Twitter keys will need to be added to the configuration file via `bot_setup.rb`.
  * All users can user a number of fun commands.
  * Users gain points for interacting in the server. Once they collect a number of point they will "level up" and be notified.

### Setup
1. Create a bot in discord.
1. Clone repository.
1. run `$ bundle` to setup the gems.
1. run `$ ruby bot_setup.rb` to configure the app (This is where the twitter and discord keys will get set).
1. run `$ redis-server usr/local/etc/redis.conf` (Make sure you have installed redis).
1. run `$ ruby bot_runner.rb`.

### Future Features
* Allow commands to be configured via `bot_setup.rb`.
* Integrate with Twitch API.
  * Post to discord when friends are live streaming.
  * When server owner goes live post to twitter (!live command will then turn to !tweet).
* Web interface for configuring bot instead of using `bot_setup.rb`.

### Have feedback, suggestions, or questions?
Submit an issue and I will get back to you as soon as possible.

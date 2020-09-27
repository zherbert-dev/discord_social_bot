require_relative '../modules/level'

def add_points(r, event)
    user = event.user
    existing_user = r.hmget(user.id.to_s, :user_name)[0]
    puts user.id

    if !existing_user.nil?
        new_points = r.hincrby(user.id.to_s, :points, 1)
        check_points(r, user, new_points, event)
    else
        r.hmset(user.id.to_s, :user_name, event.user.username, :points, 1, :level, 0)
    end
end

def check_points(r, user, new_points, event)
    if [LEVEL::ONE, LEVEL::TWO, LEVEL::THREE, LEVEL::FOUR, LEVEL::FIVE, LEVEL::SIX, LEVEL::SEVEN, LEVEL::EIGHT, LEVEL::NINE, LEVEL::TEN].include? new_points
        level_up(r, user, event)
    end
end

def level_up(r, user, event)
    new_level = r.hincrby(user.id.to_s, :level, 1)
    notify_level_up(event, new_level)
end

def notify_level_up(event, new_level)
    username = event.user.username
    event.channel.send_message("Congrats @#{username} -- you have increased to lvl #{new_level}!")
end
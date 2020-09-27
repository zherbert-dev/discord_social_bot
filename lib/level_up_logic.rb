def add_points(r, event)
    existing_user = r.hmget(event.user.id.to_s) || nil

    if existing_user
        r.incr(existing_user.points)
        #do we need to get the user again since it got updated?
        check_points(existing_user)
    else
        r.hmset(event.user.id.to_s, :user_name, event.user.username, :points, 0, :level, 0)
    end
end

def check_points(user, event)
    points = existing_user.points
    cur_level = existing_user.level
end

def level_up(r, user, event)
    r.incr(user.level)
    notify_level_up(event)
end

def notify_level_up(user, event)
    event.channel.send_message()
end
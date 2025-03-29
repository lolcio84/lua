--this library is for love2d, it won't work in clear lua

local delay = {}

local timers = {}
local nextId = 1

function delay.create(time, callback)
    local timer = {
        id = nextId,
        time = time,
        callback = callback,
        elapsed = 0,
        active = true
    }
    table.insert(timers, timer)
    nextId = nextId + 1
    return timer.id
end

function delay.update(dt)
    for i = #timers, 1, -1 do
        local timer = timers[i]
        if timer.active then
            timer.elapsed = timer.elapsed + dt
            if timer.elapsed >= timer.time then
                timer.callback()
                timer.active = false
                table.remove(timers, i)
            end
        end
    end
end

function delay.cancel(id)
    for i, timer in ipairs(timers) do
        if timer.id == id then
            timer.active = false
            table.remove(timers, i)
            break
        end
    end
end

function delay.loop(iterations, delayTime, callback)
    local count = 0
    local timer = 0

    return function(dt)
        timer = timer + dt
        if timer >= delayTime then
            timer = 0
            count = count + 1
            if count <= iterations then
                callback(count)
            else
                return true  
            end
        end
        return false  
    end
end

function delay.whileLoop(condition, delayTime, callback)
    local timer = 0

    return function(dt)
        if condition() then  
            timer = timer + dt
            if timer >= delayTime then
                timer = 0
                callback()  
            end
            return false  
        else
            return true  
        end
    end
end
return delay

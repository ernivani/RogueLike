-- Enemy.lua

Enemy = {}
Enemy.__index = Enemy

function Enemy:new(type, x, y, player)
    local obj = {
        x = x,
        y = y,
        player = player,
        type = type,
        health = type == 1 and 10 or (type == 2 and 20 or 30),  -- Health based on type
        speed = type == 1 and 200 or (type == 2 and 50 or 100),  -- Speed based on type
    }
    setmetatable(obj, Enemy)
    return obj
end

function Enemy:update(dt)
    local dx = self.player.x + 10 - self.x
    local dy = self.player.y + 10 - self.y
    local length = math.sqrt(dx * dx + dy * dy)
    if length > 0 then
        dx = dx / length
        dy = dy / length
    end

    self.x = self.x + dx * self.speed * dt
    self.y = self.y + dy * self.speed * dt
end

function Enemy:draw()
    if self.type == 1 then
        love.graphics.setColor(0, 1, 0) -- Green for low HP
    elseif self.type == 2 then
        love.graphics.setColor(1, 1, 0) -- Yellow for medium HP
    else
        love.graphics.setColor(1, 0, 0) -- Red for high HP
    end
    love.graphics.circle("fill", self.x, self.y, 10)
    -- draw the health bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x - 10, self.y + 15, 20, 5)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x - 10, self.y + 15, 20 * (self.health / (self.type == 1 and 10 or (self.type == 2 and 20 or 30))), 5)
end

return Enemy

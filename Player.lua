-- Player.lua

Player = {}
Player.__index = Player

local function checkCollision(x1, y1, radius1, x2, y2, radius2)
    local distance = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    return distance < (radius1 + radius2)
end

function Player:new(x,y,speed,lives,weapons)
    local obj = {
        x = x,
        y = y,
        speed = speed,
        lives = lives,
        weapons = weapons,
        activeWeapon = 1,
        score = 0,
    }

    setmetatable(obj, Player)
    return obj
end

function Player:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", self.x, self.y, 20, 20)

    -- draw the lives
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Lives: " .. self.lives, 10, 30)
    love.graphics.print("Score: " .. self.score, 10, 50)


    if self.weapons == nil then
        return
    end

    for _, weapon in ipairs(self.weapons) do
        weapon:draw()
    end

end

function Player:update(dt,enemies)
    local dx = (love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("q") and 1 or 0)
    local dy = (love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("z") and 1 or 0)

    local length = (dx ~= 0 or dy ~= 0) and math.sqrt(dx * dx + dy * dy) or 1

    local newX = self.x + (dx / length) * (self.speed * 100) * dt
    local newY = self.y + (dy / length) * (self.speed * 100) * dt

    self.x = math.max(0, math.min(newX, love.graphics.getWidth() - 20))
    self.y = math.max(0, math.min(newY, love.graphics.getHeight() - 20))

    -- check if the player is colliding with an enemy
    

    for i, weapon in ipairs(self.weapons) do
        weapon:update(dt,enemies)
    end
    
end


function Player:shoot(mouse_x, mouse_y)
    local dx = mouse_x - (self.x + 10)  -- Offset to shoot from the center of the player
    local dy = mouse_y - (self.y + 10)  -- Same offset for y
    local length = math.sqrt(dx * dx + dy * dy)

    if length == 0 then  -- Prevent division by zero
        length = 1
    end

    dx = dx / length
    dy = dy / length

    self.weapons[self.activeWeapon]:shoot(self.x , self.y, dx, dy)
end







return Player
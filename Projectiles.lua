-- Projectiles.lua

local Projectiles = {}
Projectiles.__index = Projectiles

function Projectiles:new( x, y, directionx, directiony, speed, damage,parent)
    local obj = {
        x = x,
        y = y,
        direction = {
            x = directionx,
            y = directiony,
        },
        speed = speed,
        damage = damage,
        parent = parent,
    }

    setmetatable(obj, Projectiles)
    return obj
end

function Projectiles:update(dt)
    self.x = self.x + self.direction.x * self.speed * dt
    self.y = self.y + self.direction.y * self.speed * dt

    if self.x < 0 or self.x > love.graphics.getWidth() or self.y < 0 or self.y > love.graphics.getHeight() then
        self.parent:removeProjectile(self)
    end

    
end

function Projectiles:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, 5)
end

return Projectiles
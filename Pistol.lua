-- Pistol.lua

local Pistol = {}
Pistol.__index = Pistol

Projectiles = require("Projectiles")
local function checkCollision(x1, y1, radius1, x2, y2, radius2)
    local distance = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    return distance < (radius1 + radius2)
end

function Pistol:new()
    local obj = {
        fireRate = 0.3,
        lastFire = 0,
        magazine = 15,
        maxAmmo = 15,
        totalAmmo = math.huge,  
        reloadTime = 1.5,
        reloadTimer = 0,
        damage = 10,
        projectileSpeed = 500,
        projectiles = {}
    }

    setmetatable(obj, Pistol)
    return obj
end


function Pistol:shoot(x, y, directionX, directionY)
    if self.reloadTimer > 0 then
        return 
    end
    if self.lastFire + self.fireRate <= love.timer.getTime() then
        if self.magazine > 0 then
            self.magazine = self.magazine - 1
            self.lastFire = love.timer.getTime()
            
            local projectile = Projectiles:new(x+10, y+10, directionX, directionY, self.projectileSpeed, self.damage,self)
            table.insert(self.projectiles, projectile)
        else
            self:reload()
        end
    end
end

function Pistol:removeProjectile(projectile)
    for i, p in ipairs(self.projectiles) do
        if p == projectile then
            table.remove(self.projectiles, i)
            break
        end
    end
end

function Pistol:reload()
    if self.totalAmmo > 0 and self.magazine < self.maxAmmo then
        self.reloadTimer = self.reloadTime
    end
end

function Pistol:update(dt,enemies)
    if self.reloadTimer > 0 then
        self.reloadTimer = self.reloadTimer - dt
        if self.reloadTimer <= 0 then
            local ammoNeeded = self.maxAmmo - self.magazine
            local ammoToReload = math.min(self.totalAmmo, ammoNeeded)
            self.magazine = self.magazine + ammoToReload
            self.totalAmmo = self.totalAmmo - ammoToReload
        end
    end

    for i = #self.projectiles, 1, -1 do
        local projectile = self.projectiles[i]
        projectile:update(dt)
        
    end
end

function Pistol:draw()
    for _, projectile in ipairs(self.projectiles) do
        projectile:draw()
    end

    -- draw the ammo
    love.graphics.setColor(1, 1, 1)
    if self.reloadTimer > 0 then
        love.graphics.print("Reloading...", 10, 10)
    else
        love.graphics.print("Ammo: " .. self.magazine .. " / " .. self.totalAmmo, 10, 10)
    end
    
end
return Pistol


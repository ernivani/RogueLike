-- entities/Player.lua
local Entity = require("entities.Entity")  -- Adjust the path according to your project structure
Player = setmetatable({}, {__index = Entity})

function Player:new(x, y, z)
    local obj = Entity:new(x, y, z)
    setmetatable(obj, {__index = Player})
    return obj
end

function Player:handleInput()
    local translation = Vector3:new(0, 0, 0)
    local rotation = 0
    if love.keyboard.isDown("up") then
        translation = translation:add(Vector3:new(0, -1, 0))
    end
    if love.keyboard.isDown("down") then
        translation = translation:add(Vector3:new(0, 1, 0))
    end
    if love.keyboard.isDown("left") then
        translation = translation:add(Vector3:new(-1, 0, 0))
    end
    if love.keyboard.isDown("right") then
        translation = translation:add(Vector3:new(1, 0, 0))
    end
    if love.keyboard.isDown("a") then
        rotation = rotation - 0.1
    end
    if love.keyboard.isDown("d") then
        rotation = rotation + 0.1
    end
    return translation, rotation
end

function Player:update(dt)
    local translation, rotation = self:handleInput()
    local newPosition = self.position:add(translation)
    local newObject3D = self.object3D:rotate(rotation)
    self.position = newPosition
    self.object3D = newObject3D
end

function Player:draw()
    self.object3D:draw()
end
return Player

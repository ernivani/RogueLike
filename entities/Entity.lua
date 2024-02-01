-- entities/Entity.lua
Entity = {}
Entity.__index = Entity
local Object3D = require("lib.Object3D") 
local Vector3 = require("lib.Vector3")

function Entity:new(x, y, z)
    local object3D = Object3D:new()  
    return setmetatable({
        position = Vector3:new(x, y, z),
        object3D = object3D
    }, Entity)
end

function Entity:translate(translation)
    local newPosition = self.position:add(translation)
    return Entity:new(newPosition.x, newPosition.y, newPosition.z)
end

function Entity:scale(scalar)
    local newObject3D = self.object3D:scale(scalar)
    return Entity:new(self.position.x, self.position.y, self.position.z, newObject3D)
end

function Entity:rotate(rotation)
    local newObject3D = self.object3D:rotate(rotation)
    return Entity:new(self.position.x, self.position.y, self.position.z, newObject3D)
end

function Entity:project(camera)
    local newPosition = self.position:project(camera)
    local newObject3D = self.object3D:project(camera)
    return Entity:new(newPosition.x, newPosition.y, newPosition.z, newObject3D)
end

function Entity:draw()
    self.object3D:draw()
end

function Entity:update(dt)
    self.object3D:update(dt)
end

return Entity

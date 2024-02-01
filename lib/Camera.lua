-- lib/Camera.lua
Camera = {}
Camera.__index = Camera

function Camera:new(position, angle, focalLength)
    return setmetatable({position = position, angle = angle, focalLength = focalLength}, Camera)
end

function Camera:translate(translation)
    local newPosition = self.position:add(translation)
    return Camera:new(newPosition, self.angle, self.focalLength)
end

function Camera:rotate(rotation)
    local newAngle = self.angle + rotation
    return Camera:new(self.position, newAngle, self.focalLength)
end

function Camera:project(object)
    local newPosition = object.position:project(self)
    local newAngle = object.angle - self.angle
    return Camera:new(newPosition, newAngle, self.focalLength)
end

return Camera


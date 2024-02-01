-- engine/Scene.lua
Scene = {}
Scene.__index = Scene

function Scene:new(name, camera, objects)
    return setmetatable({name = name, camera = camera, objects = objects}, Scene)
end

function Scene:translate(translation)
    local newCamera = self.camera:translate(translation)
    local newObjects = {}
    for i, object in ipairs(self.objects) do
        newObjects[i] = object:translate(translation)
    end
    return Scene:new(self.name, newCamera, newObjects)
end

function Scene:rotate(rotation)
    local newCamera = self.camera:rotate(rotation)
    local newObjects = {}
    for i, object in ipairs(self.objects) do
        newObjects[i] = object:rotate(rotation)
    end
    return Scene:new(self.name, newCamera, newObjects)
end

function Scene:project()
    local newCamera = self.camera:project()
    local newObjects = {}
    for i, object in ipairs(self.objects) do
        newObjects[i] = object:project()
    end
    return Scene:new(self.name, newCamera, newObjects)
end

function Scene:draw()
    for i, object in ipairs(self.objects) do
        object:draw()
    end
end

function Scene:update(dt)
    for i, object in ipairs(self.objects) do
        object:update(dt)
    end
end

return Scene

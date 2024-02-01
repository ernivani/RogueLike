-- engine/SceneManager.lua
SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager:new()
    local scenes = {}
    return setmetatable({scenes = scenes, currentScene = nil}, SceneManager)
end

function SceneManager:addScene(name, scene)
    self.scenes[name] = scene
end

function SceneManager:switchToScene(name)
    self.currentScene = self.scenes[name]
end

function SceneManager:update(dt)
    if self.currentScene then
        self.currentScene:update(dt)
    end
end

function SceneManager:draw()
    if self.currentScene then
        self.currentScene:draw()
    end
end

return SceneManager

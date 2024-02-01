-- engine/Renderer.lua
Renderer = {}
Renderer.__index = Renderer

function Renderer:new()
    return setmetatable({}, Renderer)
end

function Renderer:render(scene)
    local projectedScene = scene:project()
    projectedScene:draw()
end

return Renderer

-- engine/InputHandler.lua
InputHandler = {}
InputHandler.__index = InputHandler

function InputHandler:new()
    return setmetatable({}, InputHandler)
end

function InputHandler:handleInput()
    local translation = Vector:new(0, 0)
    local rotation = 0
    if love.keyboard.isDown("up") then
        translation = translation:add(Vector:new(0, -1))
    end
    if love.keyboard.isDown("down") then
        translation = translation:add(Vector:new(0, 1))
    end
    if love.keyboard.isDown("left") then
        translation = translation:add(Vector:new(-1, 0))
    end
    if love.keyboard.isDown("right") then
        translation = translation:add(Vector:new(1, 0))
    end
    if love.keyboard.isDown("a") then
        rotation = rotation - 0.1
    end
    if love.keyboard.isDown("d") then
        rotation = rotation + 0.1
    end
    return translation, rotation
end

return InputHandler

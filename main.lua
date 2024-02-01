-- main.lua 
local env = {
    debug = false,
}

-- Declare player at the module level so it's accessible throughout the file
local Player = require("entities.Player")
local Camera = require("lib.Camera")
local Renderer = require("engine.Renderer")
local Scene = require("engine.Scene")
local player
local scene
local camera
local renderer 


function love.load()
    local startingX, startingY, startingZ = 100, 100, 0  -- Replace with desired starting positions
    player = Player:new(startingX, startingY, startingZ)
    camera = Camera:new(Vector3:new(0, 0, -10), 0, 1)
    scene = Scene:new("MainScene", camera, {player}) 
    renderer = Renderer:new()
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    renderer:render(scene) 
end

-- main.lua

local env = {
    debug = false,
}



local Player = require("Player")
local Enemy = require("Enemy")
local Pistol = require("Pistol")
local enemies = {}
local player
local Weapons = {Pistol:new()}

-- set the random seed
math.randomseed(os.time())

function love.load()
    if env.debug then
        love.window.setMode(800, 600) 
    end

    player = Player:new(100, 100,3, 3, Weapons) 
end

function love.keypressed(key)
    if key == "escape" and env.debug then
        love.event.quit()
    end
end

local function checkCollision(x1, y1, radius1, x2, y2, radius2)
    local distance = math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    return distance < (radius1 + radius2)
end

function love.update(dt)

    if gameover then
        if love.keyboard.isDown("r") then
            for i = #enemies, 1, -1 do
                table.remove(enemies, i)
            end
            for i = #player.weapons[1].projectiles, 1, -1 do
                table.remove(player.weapons[player.activeWeapon].projectiles, i)
            end
            gameover = false
            player = Player:new(100, 100,3, 3, Weapons)
        end
        return
    end
    player:update(dt,enemies)

    -- Check if the player is colliding with an enemy
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        if checkCollision(player.x, player.y, 20, enemy.x, enemy.y, 10) then
            table.remove(enemies, i)
            player.lives = player.lives - 1
            if player.lives <= 0 then
                gameover = true
            end
        end
    end

    -- Check if a projectile is colliding with an enemy
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        for j = #player.weapons[1].projectiles, 1, -1 do
            local projectile = player.weapons[1].projectiles[j]
            if checkCollision(projectile.x, projectile.y, 5, enemy.x, enemy.y, 10) then
                enemy.health = enemy.health - projectile.damage
                table.remove(player.weapons[player.activeWeapon].projectiles, j)

                if enemy.health <= 0 then
                    table.remove(enemies, i)
                    player.score = player.score + 1
                end
                
                
            end
        end
    end

     -- Update each enemy
    for _, enemy in ipairs(enemies) do
        enemy:update(dt)
    end

    -- Example logic to spawn an enemy
    if #enemies < 5 then  -- Just an example condition
        table.insert(enemies, Enemy:new(math.random(1, 3), math.random(0, 800), math.random(0, 600), player))
    end

end

function love.draw()
    player:draw()  -- Draw the player
    

    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end

    if gameover then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Game Over!", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 10)
        love.graphics.print("Press R to restart", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 10)

    end
end

function love.mousepressed(mouse_x, mouse_y, button)
    if gameover then
        return
    end
    if button == 1 then
        player:shoot(mouse_x, mouse_y)
    end
end


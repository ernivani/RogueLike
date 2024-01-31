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
local gamestate = "menu"

-- set the random seed
math.randomseed(os.time())

function love.load()
    if env.debug then
        love.window.setMode(800, 600) 
    end

    player = Player:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2,3, 3, Weapons)
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

    if gamestate == "gameover" then
        if love.keyboard.isDown("r") then
            for i = #enemies, 1, -1 do
                table.remove(enemies, i)
            end
            for i = #player.weapons[1].projectiles, 1, -1 do
                table.remove(player.weapons[player.activeWeapon].projectiles, i)
            end
            gamestate = "game" 
            player = Player:new(100, 100,3, 3, Weapons)
        end
        
        if love.keyboard.isDown("escape") then
            love.event.quit()
        end
        return
    end

    if gamestate == "menu" then
        if love.keyboard.isDown("space") or love.keyboard.isDown("return") then
            gamestate = "game"
        end
        if love.keyboard.isDown("escape") then
            love.event.quit()
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
                gamestate = "gameover"
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
                enemy.speed = enemy.speed*1.1
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
    if #enemies < f(player.score) then
        table.insert(enemies, Enemy:new(math.random(1, enemyGenerate(player.score)), math.random(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight()), player))
    end

end

function enemyGenerate(score)
    if score < 30 then
        return 1
    elseif score < 70 then
        return math.random(1, 2)
    else
        return math.random(1, 3)
    end
end

function f(x)
    if x==0 then return 1 end
    return 0.1 * expo(x) + 0.1 * x
end

function expo(x) 
    return 0.1 * x ^ 1.1
end

function love.draw()
    player:draw()  -- Draw the player
    

    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end

    if gamestate == "gameover" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Game Over!", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 10)
        love.graphics.print("Press R to restart", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 10)
        love.graphics.print("Press Esc to quit", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 10)
        return
    end

    if gamestate == "menu" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Press Space to start", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 10)
        love.graphics.print("Press Esc to quit", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 10)
        return
    end

end

function love.mousepressed(mouse_x, mouse_y, button)
    if gamestate == "gameover" then
        return
    end
    if button == 1 then
        player:shoot(mouse_x, mouse_y)
    end
end

function love.mousereleased(mouse_x, mouse_y, button)
    if gamestate == "gameover" then
        return
    end
    if button == 1 then
        player:stopShooting()
    end
end
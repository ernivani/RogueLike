-- Initialisation des variables
local x = 400
local y = 300
local speed = 200
local lives = 3 
local projectiles = {}
local bossProjectiles = {}
local enemies = {}
local spawnRate = 1
local nextSpawn = 1
local score = 0
local gameOver = false
local shooting = false
local fireRate = 0.05   
local nextFire = 0  
local magazine = 30
local maxAmmo = 30
local totalAmmo = math.huge  
local reloading = false
local reloadTime = 0.5
local timeToReload = 0 
local pause = false
local justPaused = false
local boss = nil  
local bossHealth = 100 
local bossMaxHealth = 100
local level = 1
local baseBossSpeed = 10

local bossAttackNumber = 0

local BossBulletSPeed = 500
local bossAttackCooldown = 2


local function changeLevel()
    level = level + 1
    if level % 3 == 0 then
        fireRate = math.max(fireRate - 0.01, 0.01)
    else if level % 3 == 1 then
        maxAmmo = math.min(maxAmmo + 5, 100)
    else
        reloadTime = math.max(reloadTime - 0.1, 0.1)
    end
    end
    BossBulletSPeed = BossBulletSPeed + 50
    bossAttackCooldown = bossAttackCooldown - 0.1
end

-- Fonction de chargement des ressources de Love2D
function love.load()
    x = love.graphics.getWidth() / 2 - 25
    y = love.graphics.getHeight() / 2 - 25
end

-- Fonction de mise à jour de l'état du jeu
function love.update(dt)
    if gameOver then
        -- if r is pressed, reset the game 
        if love.keyboard.isDown("r") then
            x = love.graphics.getWidth() / 2 - 25
            y = love.graphics.getHeight() / 2 - 25
            lives = 3 
            projectiles = {}
            enemies = {}
            spawnRate = 1
            nextSpawn = 1
            score = 0
            gameOver = false
        end
        if love.keyboard.isDown("escape") then
            love.event.quit()
        end
        return
    end

    if not love.keyboard.isDown("escape") then
        justPaused = false
    end

    if pause then
        if not justPaused and love.keyboard.isDown("escape") then
            pause = false
            justPaused = true
        end
        if love.keyboard.isDown("q") then
            love.event.quit()
        end
        return
    end

    if love.keyboard.isDown("escape") and not gameOver and not justPaused then
        pause = true
        justPaused = true
    end



    if reloading then
        timeToReload = timeToReload - dt
        if timeToReload <= 0 then
            magazine = maxAmmo
            reloading = false  -- Arrêter le rechargement
        end
    else
        if love.keyboard.isDown("r") and not gameOver and magazine < 30 then
            reloading = true
            timeToReload = reloadTime
        end
        
        if shooting and not reloading then
            nextFire = nextFire - dt
            if nextFire <= 0 and magazine > 0 then
                nextFire = fireRate
                magazine = magazine - 1
                -- Votre code existant pour créer des projectiles
                local mouse_x, mouse_y = love.mouse.getPosition()
                local angle = math.atan2(mouse_y - (y + 25), mouse_x - (x + 25))
                local projectile = {
                    x = x + 25,
                    y = y + 25,
                    dx = math.cos(angle),
                    dy = math.sin(angle),
                    speed = 400
                }
                table.insert(projectiles, projectile)
            else if magazine <= 0 then
                reloading = true
                timeToReload = reloadTime
            end
            end
        end
    end



    nextSpawn = nextSpawn - dt
    -- Modify the existing nextSpawn logic to include this
    if nextSpawn <= 0 and not boss then
        nextSpawn = spawnRate
        local edge = math.random(1, 4)
        local ex, ey
        local window_width, window_height = love.graphics.getWidth(), love.graphics.getHeight()

        -- Correctly initialize ex and ey based on the random edge.
        if edge == 1 then  -- Top edge
            ex = math.random(0, window_width)
            ey = 0
        elseif edge == 2 then  -- Right edge
            ex = window_width
            ey = math.random(0, window_height)
        elseif edge == 3 then  -- Bottom edge
            ex = math.random(0, window_width)
            ey = window_height
        else  -- Left edge
            ex = 0
            ey = math.random(0, window_height)
        end

        -- Adding enemy types
        local enemyType = math.random(1, 3)
        local enemySpeed, enemyHP

        if enemyType == 1 then
            enemySpeed = 200  -- fast but low HP
            enemyHP = 1
        elseif enemyType == 2 then
            enemySpeed = 50  -- slow but high HP
            enemyHP = 3
        else
            enemySpeed = 100  -- moderate speed and HP
            enemyHP = 2
        end

        -- The rest of the code remains the same, but add speed and hp to the table.
        local enemy = {x = ex, y = ey, speed = enemySpeed, hp = enemyHP}
        table.insert(enemies, enemy)
        spawnRate = math.max(spawnRate * 0.9, 0.5)  -- 0.5 est la limite inférieure
    end

  

  -- Déplacement du joueur
    if love.keyboard.isDown("z") then
        y = math.max(0, y - speed * dt)
    end
    if love.keyboard.isDown("s") then
        y = math.min(love.graphics.getHeight() - 50, y + speed * dt)
    end
    if love.keyboard.isDown("q") then
        x = math.max(0, x - speed * dt)
    end
    if love.keyboard.isDown("d") then
        x = math.min(love.graphics.getWidth() - 50, x + speed * dt)
    end

  
  -- Mise à jour des projectiles
  for i, proj in ipairs(projectiles) do
    proj.x = proj.x + (proj.dx * proj.speed * dt)
    proj.y = proj.y + (proj.dy * proj.speed * dt)
  end
  
  -- Mise à jour des ennemis et du score
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        -- Fait bouger les ennemis vers le joueur
        local angle = math.atan2(y + 25 - enemy.y, x + 25 - enemy.x)
        enemy.x = enemy.x + math.cos(angle) * enemy.speed * dt
        enemy.y = enemy.y + math.sin(angle) * enemy.speed * dt

        local distance = math.sqrt((enemy.x - (x + 25))^2 + (enemy.y - (y + 25))^2)

        if distance < (25 + 10) then  -- 25 est le rayon du joueur, 10 est le rayon de l'ennemi
            lives = lives - 1  -- Reduce lives by 1
            enemies = {}  -- Remove all enemies
            if lives <= 0 then
                gameOver = true
            end
            break  
        end
        for j = #projectiles, 1, -1 do
            local proj = projectiles[j]
            if math.abs(proj.x - enemy.x) < 20 and math.abs(proj.y - enemy.y) < 20 then
                enemy.hp = enemy.hp - 1  -- reduce enemy HP
                table.remove(projectiles, j)
                
                if enemy.hp <= 0 then
                    table.remove(enemies, i)
                    score = score + 10
                end
                break
            end
        end
        
    end

    if score % 100 == 0 and score > 0 and boss == nil then
        boss = {x = love.graphics.getWidth() / 2, y = -100, speed = baseBossSpeed + (level - 1) * 5 }
        bossHealth = bossMaxHealth + (level - 1) * 20
        enemies = {}  -- Remove all enemies
        projectiles = {}  -- Remove all projectiles
    end
    
    -- Boss update logic
    if boss then
        boss.y = boss.y + boss.speed * dt
        if boss.y > love.graphics.getHeight() then  -- Boss reached the end, remove boss
            boss = nil
            bossHealth = 0
            lives = 0
            gameOver = true
        end

        if bossAttackCooldown <= 0 and boss then
            bossAttackCooldown = 2
            -- bossProectile va vers le joueur   
            local random = math.random(1, 3)
            if bossAttackNumber == random then
                bossAttackNumber = 0
                -- create a whole wave of projectiles
                for i = 0, 360, 10 do
                    local angle = math.rad(i)
                    local bossProjectile = {
                        x = boss.x + 50,
                        y = boss.y + 50,
                        dx = math.cos(angle),
                        dy = math.sin(angle),
                        speed = BossBulletSPeed 
                    }
                    table.insert(bossProjectiles, bossProjectile)
                end
            else if bossAttackNumber > 3 then
                bossAttackNumber = 0
                local angle = math.atan2(y - boss.y, x - boss.x)
                for i = -3, 3 do -- Create 7 projectiles in a cone
                    local angleOffset = math.rad(5 * i) -- Offset each projectile by 5 degrees
                    local bossProjectile = {
                        x = boss.x + 50,
                        y = boss.y + 50,
                        dx = math.cos(angle + angleOffset),
                        dy = math.sin(angle + angleOffset),
                        speed = BossBulletSPeed
                    }
                    table.insert(bossProjectiles, bossProjectile)
                end
            else 
                local angle = math.atan2(y - boss.y, x - boss.x)
                local bossProjectile = {
                    x = boss.x + 50,
                    y = boss.y + 50,
                    dx = math.cos(angle),
                    dy = math.sin(angle),
                    speed = BossBulletSPeed 
                }
                table.insert(bossProjectiles, bossProjectile)
            end
            end
            bossAttackNumber = bossAttackNumber + 1
        else
            bossAttackCooldown = bossAttackCooldown - dt
        end

        -- Mise à jour des projectiles du boss
        for i, proj in ipairs(bossProjectiles) do
            proj.x = proj.x + (proj.dx * proj.speed * dt)
            proj.y = proj.y + (proj.dy * proj.speed * dt)

            -- Vérifiez si le projectile a touché le joueur
            local distance = math.sqrt((proj.x - (x + 25))^2 + (proj.y - (y + 25))^2)
            if distance < 10 + 25 then  -- 25 est le rayon du joueur, 10 est le rayon du projectile du boss
                lives = lives - 1  -- Réduire les vies de 1
                table.remove(bossProjectiles, i)  -- Supprimer ce projectile
                if lives <= 0 then
                    gameOver = true
                end
                break
            end
        end

            
        
        
        for j = #projectiles, 1, -1 do
            local proj = projectiles[j]
            if boss ~= nil then 
                if proj.x > boss.x and proj.x < boss.x + 100 and proj.y > boss.y and proj.y < boss.y + 100 then
                    bossHealth = bossHealth - 1  -- reduce boss HP
                    table.remove(projectiles, j)
                    
                    if bossHealth <= 0 then
                        boss = nil
                        bossHealth = 0
                        score = score + 50
                        bossProjectiles = {}
                        changeLevel()
                    end
                    break
                end
            end 
        end
    end
end

-- Fonction de dessin de Love2D
function love.draw()
    
    if gameOver then
        love.graphics.setColor(1, 0, 0)  -- Red
        love.graphics.print("Game Over", 375, 300)  -- Approximate center of screen

        love.graphics.setColor(1, 1, 1)  -- White
        love.graphics.print("Score: " .. score, 375, 350)  -- Approximate center of screen

        love.graphics.setColor(1, 1, 1)  -- White
        love.graphics.print("Press 'r' to restart", 375, 400)  -- Approximate center of screen
        return
    end

    
    -- Dessin du joueur
    love.graphics.setColor(1, 1, 1) -- Blanc
    love.graphics.rectangle("fill", x, y, 50, 50)
    
    -- Dessin des projectiles
    love.graphics.setColor(1, 0, 0) -- Rouge
    for i, proj in ipairs(projectiles) do
        love.graphics.circle("fill", proj.x, proj.y, 5)
    end

    love.graphics.setColor(0, 0, 1) -- Bleu
    for i, proj in ipairs(bossProjectiles) do
        love.graphics.circle("fill", proj.x, proj.y, 10)
    end
    
    -- Dessin des ennemis
    love.graphics.setColor(0, 1, 0) -- Vert
    for i, enemy in ipairs(enemies) do
        if enemy.hp == 1 then
            love.graphics.setColor(0, 1, 0) -- Green for low HP
        elseif enemy.hp == 2 then
            love.graphics.setColor(1, 1, 0) -- Yellow for medium HP
        else
            love.graphics.setColor(1, 0, 0) -- Red for high HP
        end
        love.graphics.circle("fill", enemy.x, enemy.y, 10)
    end
  
    -- Dessin du score
    love.graphics.setColor(1, 1, 1) -- Blanc
    love.graphics.print("Score: " .. score, 10, 10)
    
    love.graphics.setColor(1, 1, 1) -- Blanc
    love.graphics.print("Lives: " .. lives, love.graphics.getWidth() - 50, 10)

    if reloading then
        love.graphics.print("Reloading: " .. math.ceil(timeToReload), 10, 30)
    else
        love.graphics.print("Ammo: " .. magazine .. " / " .. totalAmmo, 10, 30)
    end

    if pause then 
        love.graphics.setColor(1, 1, 1)  -- White
        love.graphics.print("Press 'escape' to resume", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 50)  -- Approximate center of screen
        
        love.graphics.setColor(1, 1, 1)  -- White
        love.graphics.print("Press 'q' to quit", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2)  -- Approximate center of screen
    end
    
    if boss then
        love.graphics.setColor(0, 0, 1) -- Bleu pour le boss
        love.graphics.rectangle("fill", boss.x, boss.y, 100, 100) -- supposons que le boss est un carré de 100x100

        love.graphics.setColor(1, 1, 1) -- Blanc
        love.graphics.print("Boss HP: " .. bossHealth, boss.x, boss.y - 20)
    end
    
end


-- Fonction appelée lorsqu'une touche de la souris est enfoncée
function love.mousepressed(mouse_x, mouse_y, button)
    if button == 1 then
      shooting = true
    end
end

function love.mousereleased(mouse_x, mouse_y, button)
    if button == 1 then
      shooting = false
    end
end
 

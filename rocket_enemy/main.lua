#!/usr/bin/env luvit
-- main.lua

function love.load()
	explodesnd = love.audio.newSource("Explosion.wav", "stream")
	explodesnd:setVolume(0.3)

    player = {
        x = 400,
        y = 300,
        speed = 200,
        heading = 0 -- Initial heading in radians (facing right)
    }

    bullets = {}
    enemies = {}

    bulletSpeed = 500
    enemySpeed = 100
    enemyRadius = 20


end

function love.update(dt)
    -- Player movement
    local dx, dy = 0, 0

    if love.keyboard.isDown("up") then
        dy = -player.speed * dt
    elseif love.keyboard.isDown("down") then
        dy = player.speed * dt
    end

    if love.keyboard.isDown("left") then
        dx = -player.speed * dt
    elseif love.keyboard.isDown("right") then
        dx = player.speed * dt
    end

    -- Update player position and heading
    player.x = player.x + dx
    player.y = player.y + dy
    player.heading = math.atan2(dy, dx)

    -- Bullet movement
    for i, bullet in ipairs(bullets) do
        bullet.x = bullet.x + bullet.dx * dt * bulletSpeed
        bullet.y = bullet.y + bullet.dy * dt * bulletSpeed

        -- Remove bullets that go off-screen
        if bullet.x < 0 or bullet.x > love.graphics.getWidth() or
           bullet.y < 0 or bullet.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    -- Enemy movement
    for i, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.dx * dt * enemySpeed
        enemy.y = enemy.y + enemy.dy * dt * enemySpeed

        -- Remove enemies that go off-screen
        if enemy.x < 0 or enemy.x > love.graphics.getWidth() or
           enemy.y < 0 or enemy.y > love.graphics.getHeight() then
            table.remove(enemies, i)
        end
    end

    -- Collision detection between bullets and enemies
    for i, bullet in ipairs(bullets) do
        for j, enemy in ipairs(enemies) do
            if distance(bullet.x, bullet.y, enemy.x, enemy.y) < enemyRadius then
                -- Remove both the bullet and the enemy
                table.remove(bullets, i)
                table.remove(enemies, j)
                explodesnd:play()
            end
        end
    end

    -- Shooting
    if love.keyboard.isDown("space") then
        local bullet = {
            x = player.x,
            y = player.y,
            dx = math.cos(player.heading),
            dy = math.sin(player.heading)
        }
        table.insert(bullets, bullet)
    end

    -- Spawn new enemies randomly
    if math.random() < 0.01 then
        local enemy = {
            x = math.random(player.x, love.graphics.getWidth()),
            y = math.random(player.y, love.graphics.getHeight()),
            dx = math.random() - 0.5,
            dy = math.random() - 0.5
        }
        table.insert(enemies, enemy)
    end
end

function love.draw()
    -- Draw player
    love.graphics.circle("fill", player.x, player.y, 10)

    -- Draw bullets
    for _, bullet in ipairs(bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 5)
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        love.graphics.circle("fill", enemy.x, enemy.y, math.random(1, enemyRadius))
    end
end

-- Helper function to calculate distance between two points
function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

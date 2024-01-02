#!/usr/bin/env luvit
-- main.lua
local vector = require "vector"
local enemies = require "enemies"
local sound = require "sound"

function love.load()
    player = {
        pos = vector(400, 300),
        speed = 100
    }

    bullets = {}
    bulletSpeed = 500

    enemies:load()
    sound:load()
    -- local direction = vector(0, 0)
    direction = vector(math.random(), math.random())

end

function love.update(dt)
    -- Player movement

    if love.keyboard.isDown("up") then
        direction.y = direction.y - 1
    elseif love.keyboard.isDown("down") then
        direction.y = direction.y + 1
    end

    if love.keyboard.isDown("left") then
        direction.x = direction.x - 1
    elseif love.keyboard.isDown("right") then
        direction.x = direction.x + 1
    end

    player.pos = player.pos + direction:norm() * player.speed * dt
    -- Bullet movement
    for i, bullet in ipairs(bullets) do
        bullet.pos = bullet.pos + bullet.direction * bulletSpeed * dt

        -- Remove bullets that go off-screen
        if bullet.pos.x < 0 or bullet.pos.x > love.graphics.getWidth() or
           bullet.pos.y < 0 or bullet.pos.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
    -- Enemy movement (orbit around the player)
    enemies:update(dt, player)
    -- Collision detection between bullets and enemies
    for i, bullet in ipairs(bullets) do
        for j, enemy in ipairs(enemies) do
            if distance(bullet.pos.x, bullet.pos.y, enemy.pos.x, enemy.pos.y) < enemy.radius then
                -- Remove both the bullet and the enemy
                table.remove(bullets, i)
                table.remove(enemies, j)
                sound.explode:play()
            end
        end
    end
    -- Shooting
    if love.keyboard.isDown("space") then
        local bullet = {
            pos = player.pos:clone(),
            direction = direction:clone():norm()
        }
        table.insert(bullets, bullet)
        sound.laser:play()
    end
    -- Spawn new enemies randomly
    enemies:spawn()
end

function love.draw()
    -- Draw player
    love.graphics.circle("fill", player.pos.x, player.pos.y, 10)

    -- Draw bullets
    for _, bullet in ipairs(bullets) do
        love.graphics.circle("fill", bullet.pos.x, bullet.pos.y, 5)
    end

    -- Draw enemies
    enemies:draw()
    love.graphics.print(string.format("(%d, %d)", player.pos.x, player.pos.y), 10, 10)
end

-- Helper function to calculate distance between two points
function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

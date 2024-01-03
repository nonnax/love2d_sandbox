#!/usr/bin/env luvit
-- main.lua
local vector = require "vector"
local enemies = require "enemies"
local sound = require "sound"
local bullets = require "bullets"
-- local camera = require "love/camera"

function love.load()
    player = {}
    player.pos = vector(400, 300)
    player.speed = 100
    player.score = 0

    enemies:load()
    sound:load()
    -- move player on start, otherwise bullets fired will be stuck in place ('_')
    direction = vector(math.random(), math.random())
    -- cam = camera()
end

function love.update(dt)
    player.hit=false
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
    bullets:update(dt, enemies, direction, sound, player)

    -- Check Player collision
    for i, enemy in ipairs(enemies) do
        if distance(player.pos, enemy.pos) < enemy.radius then
            sound.explode2:play()
            player.score = player.score - 10
            table.remove(enemies, i)
            player.hit=true
        end
    end
    -- Spawn new enemies randomly
    enemies:spawn()
    -- cam:lookAt(player.pos.x, player.pos.y)
end

function love.draw()
    -- cam:attach()
    -- Draw player
    if player.hit then
        love.graphics.setColor({1, 0, 1})
        love.graphics.circle("line", player.pos.x, player.pos.y, math.random(10, 30))
        love.graphics.setColor({1, 1, 1})
    else
        love.graphics.circle("fill", player.pos.x, player.pos.y, 10)
    end

    bullets:draw()
    enemies:draw()
    -- cam:detach()
    love.graphics.print(string.format("(%d, %d)", player.pos.x, player.pos.y), 10, 10)
    love.graphics.print(string.format("score: %d", player.score), 10, 20)

end

-- Helper function to calculate distance between two points
-- function distance(x1, y1, x2, y2)
--     return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
-- end

#!/usr/bin/env luvit
-- main.lua
local vector = require "vector"
local enemies = require "enemies"
local sound = require "sound"
local bullets = require "bullets"

function love.load()
    player = {
        pos = vector(400, 300),
        speed = 100
    }

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
    bullets:update(dt, enemies, direction, sound)
    -- Spawn new enemies randomly
    enemies:spawn()
end

function love.draw()
    -- Draw player
    love.graphics.circle("fill", player.pos.x, player.pos.y, 10)

    bullets:draw()
    enemies:draw()
    love.graphics.print(string.format("(%d, %d)", player.pos.x, player.pos.y), 10, 10)
end

-- Helper function to calculate distance between two points
-- function distance(x1, y1, x2, y2)
--     return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
-- end

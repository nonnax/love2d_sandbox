#!/usr/bin/env luvit
local vector = require "vector"
local enemies={}

function enemies:load()
    enemySpeed = 100
    enemyRadius = 20
end

function enemies:update(dt, player)
    -- Enemy movement (orbit around the player)
    for i, enemy in ipairs(self) do
        local directionToPlayer = player.pos - enemy.pos
        enemy.direction = vector(-directionToPlayer.y, directionToPlayer.x):norm()

        enemy.pos = enemy.pos + enemy.direction * enemySpeed * dt

        -- Remove enemies that go off-screen
        if enemy.pos.x < 0 or enemy.pos.x > love.graphics.getWidth() or
           enemy.pos.y < 0 or enemy.pos.y > love.graphics.getHeight() then
            table.remove(self, i)
        end
    end
end

function enemies:spawn()
    -- Spawn new enemies randomly
    if math.random() < 0.01 then
        local enemy = {
            pos = vector(math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())),
            direction = vector(0, 0), -- Initial direction, will be set in the update loop
            radius = math.random(5, enemyRadius)
        }
        table.insert(self, enemy)
    end
end

function enemies:draw()
    for _, enemy in ipairs(self) do
        love.graphics.circle("fill", enemy.pos.x, enemy.pos.y, enemy.radius)
    end
end

enemies.__index = enemies
return setmetatable({}, enemies)

-- return enemies

#!/usr/bin/env luvit

local vector = require "vector"
local enemies = {}
local LG = love.graphics

function enemies:load()
  self.enemySpeed = 100
  self.enemyRadius = 20
end

function enemies:update(dt, player, sound)
  -- Enemy movement (orbit around the player)
  for i, enemy in ipairs(self) do
    local dirToPlayer = player.pos - enemy.pos
    enemy.direction = vector(-dirToPlayer.y, dirToPlayer.x):norm()
    enemy.pos = enemy.pos + enemy.direction * enemy.speed * dt

    -- Remove enemies that go off-screen
    if enemy.pos.x < 0 or enemy.pos.x > LG.getWidth() or enemy.pos.y < 0 or
      enemy.pos.y > LG.getHeight() then table.remove(self, i) end
  -- end
    -- Check Player collision
    -- for i, enemy in ipairs(enemies) do
    if vector.dist(player.pos, enemy.pos) < enemy.radius then
        sound.explode2:play()
        player.score = player.score - 10
        table.remove(self, i)
        player.hit=true
    end
  end

end

function enemies:spawn()
  -- Spawn new enemies randomly
  if math.random() < 0.01 then
    local enemy = {}
    enemy.pos = vector(math.random(LG.getWidth()), math.random(LG.getHeight()))
    enemy.direction = vector(0, 0) -- Initial direction, will be set in the update loop
    enemy.radius = math.random(self.enemyRadius / 2, self.enemyRadius)
    enemy.speed = math.random(self.enemySpeed / 2, self.enemySpeed)

    table.insert(self, enemy)
  end
end

function enemies:draw()
  -- Draw enemies
  for _, enemy in ipairs(self) do
    LG.circle("line", enemy.pos.x, enemy.pos.y, enemy.radius)
  end
end

-- enemies.__index = enemies
-- return setmetatable({}, enemies)

return enemies

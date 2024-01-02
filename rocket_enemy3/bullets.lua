#!/usr/bin/env luvit

local LG = love.graphics
local bullets = {}

-- bullets = {}
bullets.speed = 500

function bullets:update(dt, enemies, direction, sound)
  -- Bullet movement
  for i, bullet in ipairs(self) do
    bullet.pos = bullet.pos + bullet.direction * bullets.speed * dt
    -- Remove bullets that go off-screen
    if bullet.pos.x < 0 or
       bullet.pos.x > LG.getWidth() or
       bullet.pos.y < 0 or
       bullet.pos.y > LG.getHeight() then

       table.remove(self, i)
    end
  end
  -- Enemy movement (orbit around the player)
  enemies:update(dt, player)
  -- Collision detection between bullets and enemies
  for i, bullet in ipairs(self) do
    for j, enemy in ipairs(enemies) do
      if bullets.distance(bullet.pos, enemy.pos) < enemy.radius then
        -- Remove both the bullet and the enemy
        table.remove(self, i)
        table.remove(enemies, j)
        sound.explode:play()
      end
    end
  end
  bullets:shoot(direction, sound)
end

function bullets:shoot(direction, sound)
  if love.keyboard.isDown("space") then
    local bullet = {}
    bullet.pos = player.pos:clone()
    bullet.direction = direction:clone():norm()

    table.insert(self, bullet)
    sound.laser:play()
  end
end

function bullets.distance(a, b)
    return math.sqrt((b.x - a.x)^2 + (b.y - a.y)^2)
end

function bullets:draw()
  -- Draw bullets
  for _, bullet in ipairs(self) do
    love.graphics.circle("fill", bullet.pos.x, bullet.pos.y, 5)
  end
end

return bullets

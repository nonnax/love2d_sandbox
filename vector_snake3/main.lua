#!/usr/bin/env luvit

Body = require 'body'
directions = require 'directions'
Walls = require 'background'
Shaker = require 'love/shaker'
Cam = require 'love/hump/camera'
s = require 'sound'

function love.load()
  w, h = love.graphics.getDimensions()
  body = Body(w / 2, h / 2, 5)
  body.score = 0
  body.good_score = 0
  body.health = 10^10
  maxEnemies = 5
  enemies = respawn_enemies(maxEnemies)
  dir = directions()
  s:load()
  speed = 3
  shaker = Shaker(5, 50)
  walls = Walls()
  walls.load()
  zoom = 0.90
  cam = Cam()
end

function love.update(dt)
  body.hit = false
  -- check for any earlier hits then reset hit property of enemy
  for i, e in ipairs(enemies) do
    if e.hit then table.remove(enemies, i) end
    e.hit = false
    local acc = body.pos - e.pos
    -- acc:setmag(math.random(1, 3))
    acc:limit(5)
    e.vel = e.initvel + acc*dt*speed*8
    e.pos = e.pos + e.vel*dt*speed*8
    e.pos.x = e.pos.x % w
  end

  -- refill enemies when empty
  if #enemies == 0 then
    maxEnemies = maxEnemies + 1
    enemies = respawn_enemies(maxEnemies)
  end

  for i, a in ipairs(enemies) do
    for j, b in ipairs(enemies) do
      -- must not be the same enemy
      -- check if hits another. let the other reverse velocity
      if i ~= j then
        b.when_hit(a, function()
          a.initvel = -a.initvel
        end)
      end
    end
  end

  if body.health > 0 then
    body.pos = body.pos + dir.move() * speed
    body.pos.x = body.pos.x % (w + dir.move().x * speed)
    body.pos.y = body.pos.y % (h + dir.move().y * speed)

  else
    shaker.start()
    s.explode:play()
    d = {'down', 'left', 'right'}
    body.pos = body.pos + dir.move(d[love.math.random(3)]) * speed
    body.pos.x = body.pos.x % w
  end

  if #body.tail > 20 then
    body.shrink()
  else
    body.grow()
  end

  for i, e in ipairs(enemies) do
    -- if head to head
    body.when_hit(e, function()
      e.hit = true
      -- dir.bounce()
      shaker.start()
      s.explode2:play()
      body.health = body.health - 1
      body.good_score = 0
      if body.health < 1 then body.health = 0 end
    end)
    -- score! tail is bit! enemy eaten!
    body.when_tail_hit(e.tail, function()
      e.hit = true
      body.score = body.score + 1
      body.good_score = body.good_score + 1
      -- add health after 3 consecutive eats
      if body.good_score == 3 then
        body.health = body.health + 1
        body.good_score = 0
      end
      -- dir.bounce()
      s.laser:play()
    end)

    if #e.tail > 50 then
      e.shrink()
    else
      e.grow()
    end
  end

  walls.update(dt)
  shaker.update(dt)
end

function love.keypressed(k) dir.keypressed(k, function() speed = speed * 2 end) end

function love.keyreleased(k)
  if k == 'escape' then love.event.quit() end
  dir.keypressed(k, function() speed = speed / 2 end)
end

function love.draw()
  cam:attach()
  love.graphics.push()

  love.graphics.scale(zoom, zoom)
  -- love.graphics.translate(w, h)
  shaker.draw()

  love.graphics.setColor({1, 0, 0})
  love.graphics.circle('fill', body.pos.x, body.pos.y, body.radius)
  for j, b in ipairs(body.tail) do
    love.graphics.circle('fill', b.pos.x, b.pos.y, math.random(1, b.radius / 4))
  end
  love.graphics.setColor({1, 1, 1})

  for i, enemy in ipairs(enemies) do
    love.graphics.circle('line', enemy.pos.x, enemy.pos.y,
                         math.random(enemy.radius, enemy.radius * 2))
    if enemy.hit then
      love.graphics.circle('line', enemy.pos.x, enemy.pos.y, math.random(100))
    end
    for j, e in ipairs(enemy.tail) do
      love.graphics.circle('line', e.pos.x, e.pos.y, e.radius / 4)
    end
  end
  love.graphics.pop()
  cam:detach()

  walls.draw()
  love.graphics.print(string.format("score: %d | health: %d", body.score,
                                    body.health), 10, 10)
end

function respawn_enemies(n)
  local enemies = {}
  for i = 1, n or 5 do enemies[#enemies + 1] = Body(1, math.random(h)) end
  return enemies
end

function love.resize() w, h = love.graphics.getDimensions() end

function love.wheelmoved(x, y)
    zoom = zoom + 0.05*y
    if zoom <= 0 then zoom = 0.2 end
    w, h = love.graphics.getDimensions()
end

function love.mousereleased(x, y)
    mw, mh = love.mouse.getPosition()
end

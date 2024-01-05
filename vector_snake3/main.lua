#!/usr/bin/env luvit
Body=require 'body'
directions=require 'directions'
s=require 'sound'

function love.load()
 w, h = love.graphics.getDimensions()
 body=Body(w/2, h/2, 5)
 maxEnemies=5
 enemies = respawn_enemies(maxEnemies)
 dir=directions()
 s:load()
 speed = 3
end

function love.update(dt)
  body.hit=false
  -- check for any earlier hits then reset hit property of enemy
  for i, e in ipairs(enemies) do
    if e.hit then
      table.remove(enemies, i)
    end
    e.hit=false
    local acc = body.pos - e.pos
    acc:setmag(math.random(1, 3))
    e.vel = e.initvel + acc
    e.pos = e.pos + e.vel
  end

  if #enemies == 0 then
    maxEnemies = maxEnemies + 1
    enemies = respawn_enemies(maxEnemies)
  end

  for i, a in ipairs(enemies) do
    for j, b in ipairs(enemies) do
      if i ~= j then
         b.when_hit(a, function()
           -- print('from', a.pos)
           -- a.pos=a.pos-a.pos:clone():setmag(50):rotate(math.random(math.pi))
           -- print('to', a.pos)
           a.initvel = -a.initvel
         end)

      end
    end
  end

  body.pos = body.pos + dir.move() * speed
  if #body.tail > 20 then
    body.shrink()
  else
    body.grow()
  end

  for i, e in ipairs(enemies) do
     -- if head to head
     body.when_hit(e, function()
       e.hit=true
       -- dir.bounce()
       s.explode:play()
     end)
     body.when_tail_hit(e.tail, function()
       e.hit=true
       -- dir.bounce()
       s.laser:play()
     end)

     if #e.tail > 50 then
      e.shrink()
     else
      e.grow()
     end
  end


end
function love.keypressed(k)
 dir.keypressed(k, function()
   speed = speed * 2
 end)
end

function love.keyreleased(k)
 dir.keypressed(k, function()
   speed = speed / 2
 end)
end

function love.draw()
 love.graphics.setColor({1, 0, 0})
 love.graphics.circle('fill', body.pos.x, body.pos.y, body.radius)
  for j, b in ipairs(body.tail) do
    love.graphics.circle('fill', b.pos.x, b.pos.y, math.random(1, b.radius/4))
  end
  love.graphics.setColor({1, 1, 1})

 for i, enemy in ipairs(enemies) do
    love.graphics.circle('line', enemy.pos.x, enemy.pos.y, math.random(enemy.radius, enemy.radius*2))
    if enemy.hit then
      love.graphics.circle('line', enemy.pos.x, enemy.pos.y, math.random(100))
    end
    for j, e in ipairs(enemy.tail) do
      love.graphics.circle('line', e.pos.x, e.pos.y, e.radius/4)
    end
 end
end

function respawn_enemies(n)
 local enemies={}
 for i=1, n or 5 do
    enemies[#enemies+1]=Body(1, math.random(h))
 end
 return enemies
end

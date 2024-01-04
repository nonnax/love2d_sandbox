#!/usr/bin/env luvit
vector = require 'vector'
sound = require 'sound'

function love.load()
	 h, w = love.graphics.getDimensions()

	 sound:load()
	 player = vector(100, 100)
	 player_radius = 7
	 fruit_radius = 10
	 pos_radius = 1
	 pos = vector(1, math.random(h))
	 vel = vector.random()*2
	 vel:norm()
	 initvel = vel:clone()
	 dx = 0
	 dy = 0
	 taillen = 50
	 postail = {}
	 fruits = {}
	 score = 0
	 player_speed = 3
end
function love.update(dt)
	 hit = false
	 fruit_hit = false
  -- local m = vector(love.mouse.getPosition())

	 if vector.dist(player, pos) < player_radius*2 then
	 		hit = true
	 		taillen = taillen + 1
	 		sound.laser:play()
	 end

	 for i, t in ipairs(postail) do
			 if vector.dist(player, t) < player_radius then
			 		hit = true
			 		taillen = taillen + 1
			 		sound.explode:play()
			 end
	 end

	 for i, fruit in ipairs(fruits) do
			 if vector.dist(pos, fruit) < fruit_radius*2 then
			 		score = score + 1
			 		postail = {}
			 		taillen = 0
			 		table.remove(fruits, i)
			 		sound.explode2:play()
					 pos = -pos
			 end
	 end
	 table.insert(postail, pos)

	 if #postail > taillen then
	 	 table.remove(postail, 1)
	 end

  local m = player
	 local acc = m - pos
	 acc:setmag(2.3)
	 vel=initvel+acc
	 pos = pos + vel



	 if love.keyboard.isDown("up") then
	 	 dx = 0
	 	 dy = -1
	 elseif love.keyboard.isDown("down") then
	 	 dx = 0
	 	 dy = 1
	 elseif love.keyboard.isDown("left") then
	 	 dx = -1
	 	 dy = 0
	 elseif love.keyboard.isDown("right") then
	 	 dx = 1
	 	 dy = 0
	 end
	 dir = vector(dx, dy)*player_speed
	 -- dir:setmag(3)
	 player = player + dir

		if love.math.random(1, 100) == love.math.random(1, 100) then
			  local fruit = vector(love.math.random(w), love.math.random(h))
			  table.insert(fruits, fruit)
			  if #fruits > 5 then
			  	 table.remove(fruits, love.math.random(1, #fruits))
			  end
		end

end

function love.keyreleased(k)
			if k == 'up' or k == 'down' or k == 'left' or k == 'right' then
					player_speed = player_speed * 0.5
			end
end

function love.keypressed(k)
			if k == 'up' or k == 'down' or k == 'left' or k == 'right' then
					player_speed = 3
			end
end

function love.draw()
 	love.graphics.circle('line', player.x, player.y, player_radius*2)
 	love.graphics.circle('fill', pos.x, pos.y, 5)

	 if hit then
	 	love.graphics.circle('line', player.x, player.y, math.random(1, 30))
	 end


	 for i, tail in ipairs(postail) do
	 	 love.graphics.circle('line', tail.x, tail.y, 1)
	 end

	 for i, fruit in ipairs(fruits) do
	 	 -- love.graphics.circle('line', fruit.x, fruit.y, 20)
			 -- if fruit_hit then
			 	love.graphics.circle('line', fruit.x, fruit.y, math.random(fruit_radius, fruit_radius*2))
			 -- end
	 end

	 love.graphics.print(string.format("score: %d", score), 10, 10)
end

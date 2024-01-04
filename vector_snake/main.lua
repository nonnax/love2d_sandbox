#!/usr/bin/env luvit
vector = require 'vector'
sound = require 'sound'

function love.load()
	 w, h = love.graphics.getDimensions()

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
	 fruit_player_hit = false

	 -- if player collides with the head or tail of the snake
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

	 -- fruits kills the snake, respawn a new snake
	 -- fruits collides with player and subtract 1 from score
	 -- delete the hit fruit
	 for i, fruit in ipairs(fruits) do
			 if vector.dist(pos, fruit) < fruit_radius*2 then
			 		score = score + 1
			 		postail = {}
			 		taillen = 0
			 		table.remove(fruits, i)
			 		sound.explode2:play()
					 pos = vector(1, math.random(h))
					 fruit_hit = true
			 end
			 if vector.dist(player, fruit) < fruit_radius*2 then
			 		score = score - 1
			 		table.remove(fruits, i)
			 		sound.laser:play()
					 dx = -dx
					 dy = -dy
					 fruit_player_hit = true
			 end
	 end
	 table.insert(postail, pos)

	 if #postail > taillen then
	 	 table.remove(postail, 1)
	 end

  local m = player
	 local acc = m - pos
	 acc:setmag(2.2)
	 vel = initvel+acc
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

		check_player_edges()


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
					player_speed = 3.5
			end
end

function love.draw()
	 love.graphics.setBackgroundColor({0, 0, 0})

 	love.graphics.circle('line', player.x, player.y, player_radius*2)
 	love.graphics.circle('fill', pos.x, pos.y, 5)

	 for i, tail in ipairs(postail) do
	 	 love.graphics.circle('line', tail.x, tail.y, 1)
	 end

	 if hit then
	 	love.graphics.circle('line', player.x, player.y, math.random(1, 100))
	 	love.graphics.circle('fill', pos.x, pos.y, math.random(1, 40))
	 end


	 if fruit_hit then
	 	 for i=1, 10 do
	 	 		love.graphics.setBackgroundColor({math.random(), math.random(), math.random()})
	 	 end
	 end


	 for i, fruit in ipairs(fruits) do
			 	love.graphics.circle('line', fruit.x, fruit.y, math.random(fruit_radius, fruit_radius*2))
			 	if fruit_player_hit then
			 			love.graphics.circle('fill', player.x, player.y, math.random(100))
			 	end
	 end

	 love.graphics.print(string.format("score: %d", score), 10, 10)
end

function check_player_edges()
	 if player.x > w  then
	 	 player.x = w
	 	 dx = -dx
	 elseif player.x < 0 then
	 	 player.x = 0
	 	 dx = -dx
	 elseif player.y > h then
	 	 player.y = h
	 	 dy = -dy
	 elseif player.y < 0 then
	 	 player.y = 0
	 	 dy = -dy
	 end
end

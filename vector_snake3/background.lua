#!/usr/bin/env luvit
-- Id$ nonnax Sat Jan 13 18:35:37 2024
-- https://github.com/nonnax
vector = require 'vector'
tabler = require 'tabler'

local function Walls(nwalls)
  local self={}
  self.front={}
  self.back={}

  function self.load()
     -- x pos and height of walls
     for i=1, nwalls or 10 do
       self.front[#self.front+1] = {pos=vector(love.math.random(w-10), 0), h=love.math.random(10, 200)}
       self.back[#self.back+1] = {pos=vector(love.math.random(w-10), 0), h=love.math.random(10, 200)}
     end
  end

  function self.update(dt)
    -- update inner tables
    for i, wall in ipairs(self.front) do
      wall.pos.x = wall.pos.x % w - 1
    end

    for i, wall in ipairs(self.back) do
      wall.pos.x = wall.pos.x % w - 0.7
    end
  end

  function self.draw()
   winHeight = love.graphics.getHeight()
   for i, wall in ipairs(self.front) do
     love.graphics.rectangle('fill', wall.pos.x, winHeight-wall.h*zoom, 10*zoom, wall.h*zoom)
     love.graphics.rectangle('fill', wall.pos.x, 0, 10*zoom, wall.h*zoom)
   end
   for i, wall in ipairs(self.back) do
     love.graphics.rectangle('line', wall.pos.x, winHeight-wall.h*zoom, 10*zoom, wall.h*zoom)
     love.graphics.rectangle('line', wall.pos.x, 0, 10*zoom, wall.h*zoom)
   end
  end

  return self

end

return Walls

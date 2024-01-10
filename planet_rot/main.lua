#!/usr/bin/env luvit
-- Id$ nonnax Wed Jan 10 18:42:24 2024
-- https://github.com/nonnax
Cam = require 'love/hump/camera'
vector = require 'vector'
LG=love.graphics

-- Vector class
Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
  local self = setmetatable({}, Vector)
  self.x = x or 0
  self.y = y or 0
  return self
end

function Vector:add(v)
  return Vector.new(self.x + v.x, self.y + v.y)
end

function Vector:sub(v)
  return Vector.new(self.x - v.x, self.y - v.y)
end

function Vector:mult(scalar)
  return Vector.new(self.x * scalar, self.y * scalar)
end

function Vector:magSq()
  return self.x^2 + self.y^2
end

function Vector:normalize()
  local mag = math.sqrt(self:magSq())
  if mag > 0 then
    self.x = self.x / mag
    self.y = self.y / mag
  end
end

-- Main Love2D code
local planet
local sat
colors = {{0, 0, 1}, {0, 1, 1}, {0, 1, 0.5}, {0, 0.5, 0.5}, {1, 0.5, 0}, {0.5, 1, 1}}

function love.load()
  love.window.setTitle("Orbiting with Gravity - Love2D")
  love.window.setMode(600, 600)
  W, H = LG.getDimensions()
  planet = Vector.new(0, 0)
  sats = createSats(planet)
  zoom = 1

  print(#colors)
end

function love.update(dt)
  updateSats(t)
  -- updateSat(dt)
  -- applyGravity()
end

function love.draw()
  love.graphics.translate(W, H)
  love.graphics.scale(zoom, zoom)
  -- love.graphics.setBackgroundColor(255, 255, 255)
  -- love.graphics.setColor(0, 0, 0)

  -- Draw the planet
  love.graphics.circle("fill", planet.x, planet.y, 25)

  -- Draw the sat
  drawSats()
end

function updateSat(sat)
  -- Define the orbit parameters
  -- Update the sat position using Vector class
  local t = love.timer.getTime()
  local orbit = Vector.new(math.cos(sat.speed * t), -math.sin(sat.speed * t)):mult(sat.radius)
  local vel = orbit:sub(sat.pos)
  vel:normalize()
  local acc = orbit:add(vel)
  sat.pos = planet:add(acc)
  -- sat.pos = planet:add(acc)
  return sat
end

function applyGravity(sat)
  -- Define gravitational parameters
  local gravitationalConstant = 0.1

  -- Calculate the gravitational force using Vector class
  local force = planet:sub(sat.pos)
  local distanceSquared = force:magSq()
  force:normalize()
  force = force:mult(gravitationalConstant / distanceSquared)

  -- Apply the gravitational force to the sat
  sat.pos = sat.pos:add(force)
  return sat
end

function createSats(planet)
  local sats = {}
  local radiusSet={}
  local speedSet={0.2*0.5}

  for i=1, 250 do
    local radius = 2

    while radiusSet[radius] do
      radius = radius + love.math.random()*1.05
    end
    radiusSet[radius]=true

    local speed =  0.2
    while speedSet[speed] do
      speed = speed + love.math.random()*1.001
    end
    speedSet[speed]=true

    local sat = {}

    sat.pos = Vector.new(planet.x + love.math.random(1, 100), planet.y )
    sat.radius = radius + i*30
    sat.speed = speed
    sat.trail = {}
    sat.color = colors[love.math.random(1, #colors)] or {1, 0, 1}
    sats[#sats+1] = sat

  end
  return sats
end

function updateSats(dt)
  for i, sat in ipairs(sats) do
     t = love.timer.getTime()*1
     local sat = applyGravity(updateSat(sat))
     sats[i] = sat
     sat.trail[#sat.trail+1] = sat.pos
     if #sat.trail > 100 then table.remove(sat.trail, 1) end
  end
end

function drawSats()
  for i, sat in ipairs(sats) do
    -- Draw the sat
    love.graphics.setColor(sat.color)
    love.graphics.circle("fill", sat.pos.x, sat.pos.y, 10)
    love.graphics.print(sat.speed, sat.pos.x, sat.pos.y)
    for j, t in ipairs(sat.trail) do
      love.graphics.circle("fill", t.x, t.y, 1)
    end
  end
end

function love.wheelmoved(x, y)
  zoom = zoom + 0.01*y
  if zoom < 0 then zoom = 0 end
end

function love.mousereleased(x, y)
  W, H = x, y
end

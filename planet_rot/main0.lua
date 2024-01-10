#!/usr/bin/env luvit
-- Id$ nonnax Wed Jan 10 18:42:24 2024
-- https://github.com/nonnax
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
local satellite

function love.load()
  love.window.setTitle("Orbiting with Gravity - Love2D")
  love.window.setMode(600, 600)
  W, H = LG.getDimensions()
  planet = Vector.new(W / 2, H / 2)
  satellite = Vector.new(planet.x + 100, planet.y)
end

function love.update(dt)
  t = love.timer.getTime()*10
  updateSatellite(dt)
  applyGravity()
end

function love.draw()
  love.graphics.setBackgroundColor(255, 255, 255)
  love.graphics.setColor(0, 0, 0)

  -- Draw the planet
  love.graphics.circle("fill", planet.x, planet.y, 25)

  -- Draw the satellite
  love.graphics.setColor(200, 0, 0)
  love.graphics.circle("fill", satellite.x, satellite.y, 10)
  love.graphics.print(love.timer.getFPS())
end

function updateSatellite(dt)
  -- Define the orbit parameters
  local radius = 100
  local speed = 0.2 * 2

  -- Update the satellite position using Vector class
  -- local orbit = Vector.new(math.cos(speed * love.timer.getTime()), math.sin(speed * love.timer.getTime())):mult(radius)

  local orbit = Vector.new(math.cos(speed * t), math.sin(speed * t)):mult(radius)
  satellite = planet:add(orbit)
end

function applyGravity()
  -- Define gravitational parameters
  local gravitationalConstant = 0.1

  -- Calculate the gravitational force using Vector class
  local force = planet:sub(satellite)
  local distanceSquared = force:magSq()
  force:normalize()
  force = force:mult(gravitationalConstant / distanceSquared)

  -- Apply the gravitational force to the satellite
  satellite = satellite:add(force)
end

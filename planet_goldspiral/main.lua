#!/usr/bin/env luvit
tabler=require 'tabler'
-- Define the golden spiral parameters
local a = 15  -- Scaling factor
local gb = 0.12  -- Angular speed

-- Planetary parameters
local planets = {}
local numPlanets = 9

function love.load()
    love.window.setTitle("Golden Spiral Planetary Orbits")
    love.window.setMode(800, 800)
    w, h = love.graphics.getDimensions()
    -- Initialize planets
    for i = 1, numPlanets do
        local planet = {
            radius = 20 + i * 0.0010,  -- Adjust the initial radius for each planet
            angle = math.random(math.pi*4),
            tail = {},
            color={math.random(), math.random(), math.random()},
            b = math.random(0.12),
            a = i*2
        }
        table.insert(planets, planet)
    end
    frame = 0
end

function love.update(dt)
    frame = frame +  1
    for _, planet in ipairs(planets) do
        -- Update the angle based on the golden spiral equation
        -- if frame % 5 == 0 then
            -- planet.angle = planet.angle + planet.b * dt
            planet.angle = planet.angle + planet.b * dt
        -- end
        -- Calculate the position based on the golden spiral equation
        planet.x = planet.a * math.exp(gb * planet.angle) * math.cos(planet.angle)
        planet.y = planet.a * math.exp(gb * planet.angle) * math.sin(planet.angle)
        table.insert(planet.tail, {x=planet.x, y=planet.y})
        if #planet.tail > 550 then
            table.remove(planet.tail, 1)
        end
    end
end

function love.draw()
    -- love.graphics.translate(w/2, h/2)
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 5)  -- Central star

    for _, planet in ipairs(planets) do
        -- Draw the planets
        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("fill", love.graphics.getWidth() / 2 + planet.x, love.graphics.getHeight() / 2 + planet.y, planet.radius/10)
        love.graphics.setColor(planet.color)

        for _, tail in ipairs(planet.tail) do
            love.graphics.circle("fill", love.graphics.getWidth() / 2 + tail.x, love.graphics.getHeight() / 2 + tail.y, 0.5)
        end
    end
end

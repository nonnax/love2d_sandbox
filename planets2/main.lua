#!/usr/bin/env luvit
-- main.lua

local function windowInit()
    w, h = love.graphics.getDimensions()
end

function love.load()
	music = love.audio.newSource("suspense.wav", "stream")
	music:setLooping(true)
	music:setVolume(0.2)
	music:play()

    love.window.setMode(800, 600, {resizable=true, vsync=0, minwidth=400, minheight=300})
    -- w, h = love.graphics.getDimensions()
    windowInit()
    planets = {}

    -- Define planets in our solar system with realistic initial conditions
    planets["Sun"] = createPlanet(0, 0, 0, 0, 1989000)  -- mass of the Sun in Earth masses

    planets["Mercury"] = createPlanet(57.9, 0, 0, 47.87, 0.055)  -- semi-major axis, eccentricity, inclination
    planets["Venus"] = createPlanet(108.2, 0, 0, 35.02, 0.815)
    planets["Earth"] = createPlanet(149.6, 0, 0, 29.78, 1)
    planets["Mars"] = createPlanet(227.9, 0, 0, 24.077, 0.107)
    planets["Jupiter"] = createPlanet(778.3, 0, 0, 13.07, 317.8)
    planets["Saturn"] = createPlanet(1427.0, 0, 0, 9.68, 95.16)
    planets["Uranus"] = createPlanet(2871.0, 0, 0, 6.81, 14.54)
    planets["Neptune"] = createPlanet(4497.1, 0, 0, 5.43, 17.15)
    G = 6.674 * (10^-3)  -- gravitational constant
    G = G * 10

end

function love.update(dt)
    updatePlanets(dt)
end

function love.draw()
    drawPlanets()
end

function createPlanet(distance, eccentricity, inclination, velocity, mass)
    -- local angle = love.math.random() * 2 * math.pi
    local angle = love.math.random() * math.pi
    local x = distance * math.cos(angle)
    local y = distance * math.sin(angle)
    local vx = -velocity * math.sin(angle)
    local vy = velocity * math.cos(angle)

    return {x = x, y = y, vx = vx, vy = vy, mass = mass}
end

function updatePlanets(dt)
    for _, planet in pairs(planets) do
        local ax, ay = 0, 0  -- acceleration components

        for _, other in pairs(planets) do
            if planet ~= other then
                local dx = other.x - planet.x
                local dy = other.y - planet.y
                local distance = math.sqrt(dx^2 + dy^2)

                local force = (G * planet.mass * other.mass) / (distance^2)
                local angle = math.atan2(dy, dx)

                ax = ax + force * math.cos(angle) / planet.mass
                ay = ay + force * math.sin(angle) / planet.mass
            end
        end

        planet.vx = planet.vx + ax * dt
        planet.vy = planet.vy + ay * dt

        planet.x = planet.x + planet.vx * dt
        planet.y = planet.y + planet.vy * dt
    end
end

function drawPlanets()
   local scale = 0.08
   love.graphics.push()
   love.graphics.translate(w/2, h/2)
    for x, planet in pairs(planets) do
        local size = planet.mass/1.2
        love.graphics.setColor({1, 1, 1})
        if x=='Sun'  then
            size = 4
            love.graphics.setColor({0, 1, 0})
        elseif x=='Jupiter'or x=='Saturn' then
            love.graphics.setColor({1, 0, 0})
            size = 3
        elseif x=='Neptune'or x=='Uranus' then
            love.graphics.setColor({0, 0, 1})
            size = 2
        elseif size < 1 then
            size = 1
        end
        love.graphics.circle("fill", planet.x * scale, planet.y * scale, size)
    end
    love.graphics.pop()
end

function love.resize()
   windowInit()
end


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
    G = G * 8 -- adjustment for simulation, 7 minimum too keep planets in orbit

    frames = 0
    trace = false
end

function love.update(dt)
    updatePlanets(dt)
    if love.keyboard.isDown("space") then
        trace = not trace
    end
end

function love.mousereleased( x, y, button )
    w, h = x, y
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

    return {x = x, y = y, vx = vx, vy = vy, mass = mass, tail={}, sun_distance=0}
end

function updatePlanets(dt)
    for name, planet in pairs(planets) do
        local ax, ay = 0, 0  -- acceleration components

        for x_name, other in pairs(planets) do
            if planet ~= other then
                local dx = other.x - planet.x
                local dy = other.y - planet.y

                local distance = math.sqrt(dx^2 + dy^2)
                local angle = math.atan2(dy, dx)

                local force = (G * planet.mass * other.mass) / (distance^2)

                ax = ax + force * math.cos(angle) / planet.mass
                ay = ay + force * math.sin(angle) / planet.mass

                if x_name == 'Sun' then
                    planet.sun_distance=distance
                end
            end
        end

        planet.vx = planet.vx + ax * dt
        planet.vy = planet.vy + ay * dt

        planet.x = planet.x + planet.vx * dt
        planet.y = planet.y + planet.vy * dt

        if frames % 5 == 0 then
            table.insert(planet.tail, {x=planet.x, y=planet.y})
            if #planet.tail > 750 then
                table.remove(planet.tail, 1)
            end
        end
    end
    frames = frames + 1
end

function drawPlanets()
   local scale = 0.198
   love.graphics.push()
   love.graphics.translate(w, h)
   -- love.graphics.translate(love.mouse.getPosition())
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
        if x=='Sun' then
            love.graphics.circle("line", planet.x * scale, planet.y * scale, size)
        else
            love.graphics.circle("fill", planet.x * scale, planet.y * scale, size)
        end

        for i, t in ipairs(planet.tail) do
           love.graphics.circle("fill", t.x * scale, t.y * scale, 0.2)
        end

        if trace then
           -- local width = love.graphics.getLineWidth( )
           love.graphics.setLineWidth(0.1)
           love.graphics.line(0, 0, planet.x * scale, planet.y * scale)
           love.graphics.print(x..':'..math.ceil(planet.sun_distance), planet.x * scale, planet.y * scale)
           -- love.graphics.setLineWidth(width)
        end

    end
    love.graphics.pop()
    local row=1
    for x, planet in pairs(planets) do
        love.graphics.print(x..':'..math.ceil(planet.sun_distance), 0, row)
        row = row + 15
    end
end

function love.resize()
   windowInit()
end


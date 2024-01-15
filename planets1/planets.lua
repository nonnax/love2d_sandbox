#!/usr/bin/env luvit
-- Id$ nonnax Wed Jan 10 22:34:32 2024
-- https://github.com/nonnax

function createPlanet(distance, eccentricity, inclination, velocity, mass)
    local angle = love.math.random() * 2 * math.pi

    -- Ensure counter-clockwise rotation in the inverted y-axis system
    if angle < math.pi then
        angle = angle + math.pi
    else
        angle = angle - math.pi
    end

    local x = distance * math.cos(angle)
    local y = distance * math.sin(angle)
    local vx = velocity * math.sin(angle)
    local vy = -velocity * math.cos(angle)

    return { x = x, y = y, vx = vx, vy = vy, mass = mass, rmin=10^5, rmax=0, trajectory={} }
end

function updatePlanets(dt)
    GConstant = 6.674 * (10 ^ -2) -- sim gravitational constant
    GR = 1.61803399
    G = GConstant
    G = G * GR * 0.62 -- ADJUSTMENT: to attract planets in orbit range

    for _, planet in pairs(planets) do
        local ax, ay = 0, 0  -- acceleration components

        local dx = sun.x - planet.x
        local dy = sun.y - planet.y
        local distance = math.sqrt(dx^2 + dy^2)

        local force = (G * sun.mass * planet.mass) / (distance^2)
        local angle =  math.atan2(dy, dx)

        ax = force * math.cos(angle) / planet.mass
        ay = force * math.sin(angle) / planet.mass

        planet.vx = planet.vx + ax * dt
        planet.vy = planet.vy + ay * dt

        planet.x = planet.x + planet.vx * dt
        planet.y = planet.y + planet.vy * dt
        planet.distance = distance

        if planet.rmin > distance then planet.rmin = distance end
        if planet.rmax < distance then planet.rmax = distance end

        planet.trajectory[#planet.trajectory+1] = {x=planet.x, y=planet.y}
        if #planet.trajectory > math.pi*100 then table.remove(planet.trajectory, 1) end
    end
end

function drawSun()
    love.graphics.setColor(1, 1, 0)  -- Set color to yellow for the sun
    love.graphics.circle("fill", sun.x, sun.y, 20)
    love.graphics.setColor(1, 1, 1)  -- Reset color to white
end

function drawPlanets()
    w, h = LG.getDimensions()
    for name, planet in pairs(planets) do
        love.graphics.circle("fill", planet.x, planet.y, 10)
        love.graphics.line(0, 0, planet.x, planet.y)
        love.graphics.print(string.format("%s %.2f", name, planet.distance), planet.x, planet.y)
        for i, t in ipairs(planet.trajectory) do
            love.graphics.circle('fill', t.x, t.y, 1)
        end
    end
end

function printStats()
    row = 20
    for name, planet in pairs(planets) do
        love.graphics.print(string.format("% 8s RMIN:%10.2f RMAX:% 9.2f RAVG:%.2f", name, planet.rmin, planet.rmax, (planet.rmin+planet.rmax)/2), 20, h-row)
        row = row + 15
    end
end


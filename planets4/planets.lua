#!/usr/bin/env luvit
-- Id$ nonnax Sun Jan  7 16:02:59 2024
-- https://github.com/nonnax
colors = require 'love_colors'
-- colors={
-- red={1,0,0},
-- orange = { 1,0,1 },
-- teal = { 0 ,1 ,1 },
-- white={1,1,1},
-- liWhite = { .5,.5,.5 },
-- blue={0,0,1},
-- liBlue={0,0,.5},
-- green={0,1,0},
-- liGreen = { 0,.1,0 },
-- yellow={1,1,0},
-- liYellow = {.5 ,.5 ,0 },
-- blank ={0,0,0,0},
-- black={0,0,0},
-- }

function createPlanet(distance, eccentricity, inclination, velocity, mass)
    -- local angle = love.math.random() * 2 * math.pi
    local angle = love.math.random(math.pi * 4)
    local x = distance * math.cos(angle)
    local y = distance * math.sin(angle)
    local vx = -velocity * math.sin(angle)
    local vy = velocity * math.cos(angle)

    return {x = x, y = y, vx = vx, vy = vy, mass = mass, tail={}, sun_distance=0, sun_force=0, dmin=10^5, dmax=0}
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
                    planet.sun_force=force
                end
                planet[x_name.."_force"]=force
            end
        end

        planet.vx = planet.vx + ax * dt
        planet.vy = planet.vy + ay * dt


        planet.x = planet.x + planet.vx * dt
        planet.y = planet.y + planet.vy * dt

        if planet.sun_distance < planet.dmin then planet.dmin = planet.sun_distance end
        if planet.sun_distance > planet.dmax then planet.dmax = planet.sun_distance end

        if frames % 20 == 0 then
            table.insert(planet.tail, {x=planet.x, y=planet.y})
            if #planet.tail > 950 then
                table.remove(planet.tail, 1)
            end
        end
    end
    frames = frames + 1
end

function drawPlanets()
   love.graphics.push()
   love.graphics.translate(w, h)
    for x, planet in pairs(planets) do
        local size = planet.mass/1.2
        love.graphics.setColor({1, 1, 1})
        if x=='Sun'  then
            size = 4
            love.graphics.setColor({0, 1, 0})
        elseif x=='Mercury' then
            love.graphics.setColor(colors.darkgrey)
        elseif x=='Earth' then
            size = 1.5
            love.graphics.setColor(colors.yellowgreen)
        elseif x=='Mars' then
            size = 1.2
            love.graphics.setColor(colors.darkred)
        elseif x=='Jupiter' then
            love.graphics.setColor(colors.violet)
            size = 3.5
        elseif x=='Saturn' then
            love.graphics.setColor(colors.brown)
            size = 3
        elseif x=='Uranus' then
            love.graphics.setColor(colors.darkgreen)
            size = 2
        elseif x=='Neptune'then
            love.graphics.setColor(colors.darkmagenta)
            size = 2.2
        elseif size < 1 then
            size = 1
        end

        size = size * scale

        if x=='Sun' then
            love.graphics.circle("fill", planet.x * scale, planet.y * scale, math.random(size-2, size))
        else
            love.graphics.circle("fill", planet.x * scale, planet.y * scale, size)
        end

        for i, t in ipairs(planet.tail) do
           love.graphics.circle("fill", t.x * scale, t.y * scale, 0.2)
        end

        if trace then
           love.graphics.setLineWidth(0.1)
           love.graphics.line(0, 0, planet.x * scale, planet.y * scale)
           love.graphics.print(string.format("%s: %d", x, planet.sun_distance), planet.x * scale, planet.y * scale)
        end

    end
    love.graphics.pop()
    love.graphics.setColor({1, 1, 1})
    love.graphics.print(string.format("% 10s\t% 9s % 17s\t% 11s % 10s", 'planet', 'dist', 'dmin/dmax', 'mass', 'force/sun'), 0, 0)

    local row=10
    for x, planet in pairs(planets) do
        if x=='Sun'  then
            love.graphics.setColor({0, 1, 0})
        elseif x=='Jupiter'then
            love.graphics.setColor(colors.violet)
        elseif x=='Saturn' then
            love.graphics.setColor(colors.brown)
        elseif x=='Uranus' then
            love.graphics.setColor(colors.darkgreen)
        elseif x=='Neptune'then
            love.graphics.setColor(colors.darkmagenta)
        elseif x=='Earth' then
            love.graphics.setColor(colors.yellowgreen)
        elseif x=='Mercury' then
            love.graphics.setColor(colors.darkgrey)
        elseif x=='Mars' then
            love.graphics.setColor(colors.darkred)
        else
            love.graphics.setColor({1, 1, 1})
        end


        love.graphics.print(string.format("% 10s: % 9.3f (%9.1f/%9.1f) % 12.3f % 9.3f", x, planet.sun_distance, planet.dmin, planet.dmax, planet.mass, planet.sun_force), 0, row)

        row = row + 12
    end
    love.graphics.setColor({1, 1, 1})
    love.graphics.print(string.format("sim G^-2:%f x f:%f = %f", GConstant, factor, G), 0, Height - 40)
    love.graphics.print(string.format("f: % .3f/%.3f",  GR, adjust/GR), 0, Height - 30)
    love.graphics.print("mouse:center/resize | space:trace | keypad(8, 2):gravity+-(0.01) | esc:quit", 0, Height - 20)

end



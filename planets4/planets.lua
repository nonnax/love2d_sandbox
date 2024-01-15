#!/usr/bin/env luvit

-- Id$ nonnax Sun Jan  7 16:02:59 2024
-- https://github.com/nonnax
colors = require 'love_colors'

function createPlanet(distance, eccentricity, inclination, velocity, mass)
  -- local angle = love.math.random(-math.pi * 4)
  local angle = love.math.random() * 2 * math.pi
  local x = distance * math.cos(angle)
  local y = distance * math.sin(angle)
  local vx = velocity * math.sin(angle)
  local vy = -velocity * math.cos(angle)

  return {
    x = x,
    y = y,
    vx = vx,
    vy = vy,
    mass = mass,
    tail = {},
    sun_distance = 0,
    sun_force = 0,
    dmin = 10 ^ 5,
    dmax = 0,
    size = 1,
    color = "white"
  }
end

function loadPlanets()
  planets = {}

  -- Define planets initial conditions
  -- TO BE IMPLEMENTED: semi-major axis, eccentricity, inclination
  planets["Sun"]     = createPlanet(0, 0, 0, 0, 1989000) -- mass of the Sun in Earth masses
  planets["Mercury"] = createPlanet(57.9, 0, 0, 47.87, 0.055)
  planets["Venus"]   = createPlanet(108.2, 0, 0, 35.02, 0.815)
  planets["Earth"]   = createPlanet(149.6, 0, 0, 29.78, 1)
  planets["Mars"]    = createPlanet(227.9, 0, 0, 24.077, 0.107)
  planets["Jupiter"] = createPlanet(778.3, 0, 0, 13.07, 317.8)
  planets["Saturn"]  = createPlanet(1427.0, 0, 0, 9.68, 95.16)
  planets["Uranus"]  = createPlanet(2871.0, 0, 0, 6.81, 14.54)
  planets["Neptune"] = createPlanet(4497.1, 0, 0, 5.43, 17.15)

  planets["Sun"].color     = "yellow"
  planets["Mercury"].color = "white"
  planets["Venus"].color   = "grey"
  planets["Earth"].color   = "yellowgreen"
  planets["Mars"].color    = "red"
  planets["Jupiter"].color = "plum"
  planets["Saturn"].color  = "brown"
  planets["Uranus"].color  = "pink"
  planets["Neptune"].color = "orangered"

  planets["Sun"].size     =  4
  planets["Mercury"].size =  1
  planets["Venus"].size   =  1.2
  planets["Earth"].size   =  1.5
  planets["Mars"].size    =  1.1
  planets["Jupiter"].size =  3.5
  planets["Saturn"].size  =  3
  planets["Uranus"].size  =  2
  planets["Neptune"].size =  2.2

  GConstant = 6.674 * (10 ^ -2) -- sim gravitational constant
  G = GConstant
  GR = 1.61803399
  adjust = 0.62
  factor = GR * adjust
  G = G * factor -- ADJUSTMENT: to attract planets in orbit range
end

function updatePlanets(dt)
  for name, planet in pairs(planets) do
    local ax, ay = 0, 0 -- acceleration components

    for x_name, other in pairs(planets) do
      if planet ~= other then
        local dx = other.x - planet.x
        local dy = other.y - planet.y

        local distance = math.sqrt(dx ^ 2 + dy ^ 2)
        local angle = math.atan2(dy, dx)

        local force = (G * planet.mass * other.mass) / (distance ^ 2)

        ax = ax + force * math.cos(angle) / planet.mass
        ay = ay + force * math.sin(angle) / planet.mass

        if x_name == 'Sun' then
          planet.sun_distance = distance
          planet.sun_force = force
        end
        -- planet[x_name.."_force"]=force
      end
    end

    -- GOOD FOR NOW: semi-implicit euler (symplectic euler), not accurate
    -- candidate integrators: verlet, runge-kutta 4 (RK4)?

    planet.vx = planet.vx + ax * dt
    planet.vy = planet.vy + ay * dt

    planet.x = planet.x + planet.vx * dt
    planet.y = planet.y + planet.vy * dt

    -- min/max distance ranges
    if planet.sun_distance < planet.dmin then
      planet.dmin = planet.sun_distance
    end
    if planet.sun_distance > planet.dmax then
      planet.dmax = planet.sun_distance
    end

    -- outline orbital paths
    if frames % 20 == 0 then
      table.insert(planet.tail, {x = planet.x, y = planet.y})
      if #planet.tail > 950 then table.remove(planet.tail, 1) end
    end
  end
  frames = frames + 1
end

function drawPlanets()
  love.graphics.push()

  -- sun follows mouse-click release
  love.graphics.translate(w, h)

  for x, planet in pairs(planets) do

    love.graphics.setColor(colors[planet.color])

    size = planet.size * scale

    if x == 'Sun' then
      love.graphics.circle("fill", planet.x * scale, planet.y * scale,
                           math.random(size - 2, size))
    else
      love.graphics.circle("fill", planet.x * scale, planet.y * scale, size)
    end

    for i, t in ipairs(planet.tail) do
      love.graphics.circle("fill", t.x * scale, t.y * scale, 0.2)
    end

    -- draw radial trace lines, makes everything easier to see :-)
    if trace then
      love.graphics.setLineWidth(0.1)
      love.graphics.line(0, 0, planet.x * scale, planet.y * scale)
      love.graphics.print(string.upper(string.format("%s: %d", x, planet.sun_distance)),
                          planet.x * scale, planet.y * scale)
    end

  end
  love.graphics.pop()
  love.graphics.setColor(colors.white)
  local header = string.format("% 10s\t% 9s % 17s\t% 11s % 10s", 'body',
                                      'r', 'r(extent)', 'mass', 'force/sun')
  love.graphics.print(string.upper(header), 0, 5)

  local row = 15
  for x, planet in pairs(planets) do
    -- love.graphics.setColor(colors[planet.color])
    local info = string.format(
                              "% 10s: % 9.3f (%9.1f/%9.1f) % 12.3f % 9.3f", x,
                              planet.sun_distance, planet.dmin, planet.dmax,
                              planet.mass, planet.sun_force)
    love.graphics.print(string.upper(info), 0, row)
    row = row + 12
  end

end


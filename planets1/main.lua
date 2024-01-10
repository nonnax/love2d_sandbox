#!/usr/bin/env luvit
-- Id$ nonnax Wed Jan 10 20:01:03 2024
-- https://github.com/nonnax
require 'planets'
LG=love.graphics
Lm=love.mouse

function love.load()
    W, H = LG.getDimensions()
    frames = 0
    font = love.graphics.newFont( 'Mononoki_Nerd_Font_Complete_Mono_Regular.ttf', 10)
    love.graphics.setFont(font)
    love.graphics.setLineStyle( 'smooth' )
    love.graphics.setLineWidth( 0.25 )

    sun = createPlanet(0, 0, 0, 0, 1989000)  -- Sun
    planets = {}

    -- Define planets in our solar system with realistic initial conditions
    planets["Mercury"] = createPlanet(57.9, 0, 0, 47.87, 0.055)  -- semi-major axis, eccentricity, inclination
    planets["Venus"] = createPlanet(108.2, 0, 0, 35.02, 0.815)
    planets["Earth"] = createPlanet(149.6, 0, 0, 29.78, 1)
    planets["Mars"] = createPlanet(227.9, 0, 0, 24.077, 0.107)
    planets["Jupiter"] = createPlanet(778.3, 0, 0, 13.07, 317.8)
    planets["Saturn"] = createPlanet(1427.0, 0, 0, 9.68, 95.16)
    planets["Uranus"] = createPlanet(2871.0, 0, 0, 6.81, 14.54)
    planets["Neptune"] = createPlanet(4497.1, 0, 0, 5.43, 17.15)
    zoom = 0.2
    angle = 0
    pause = false
end

function love.update(dt)
    if not pause then updatePlanets(dt) end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(W, H)
    love.graphics.scale(zoom, zoom)
    drawPlanets()
    drawSun()
    love.graphics.pop()
    printStats()
end

function love.wheelmoved(x, y)
    zoom = zoom + 0.05*y
    if zoom <= 0 then zoom = 0.2 end
end

function love.mousereleased(x, y, b)
    W, H = x, y
end

function love.keyreleased(key)
    if key == 'escape' then love.event.quit() end
    if key == 'space' then pause = not pause end
end


#!/usr/bin/env luvit
require 'planets'
colors=require 'love_colors'
-- Id$ nonnax Sun Jan  7 15:10:49 2024
-- https://github.com/nonnax
-- main.lua

local function windowInit()
    w, h = love.graphics.getDimensions()
    Width, Height = w, h
end

local function clearTails()
    for name, planet in pairs(planets) do
        planet.tail={}
        planet.dmin = 10^5
        planet.dmax = 0
    end

end

function love.load()
	-- music = love.audio.newSource("suspense.wav", "stream")
	-- music:setLooping(true)
	-- music:setVolume(0.2)
    love.window.setTitle('Solar synchronicity dance - Randy Evangelista')
    love.window.setMode(800, 600, {resizable=true, vsync=0, minwidth=400, minheight=300})
    -- w, h = love.graphics.getDimensions()
    windowInit()
    w, h = 10, 10
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
    -- G = 6.674 * (10^-3)  -- gravitational constant
    GConstant = 6.674 * (10^-2)  -- gravitational constant
    G = GConstant
    GR = 1.61803399
    adjust = 0.62
    factor = GR * adjust
    G = G * factor -- adjustment for simulation to keep planets in orbit

    frames = 0
    trace = true
    play = false
    scale = 0.198
    font = love.graphics.newFont( 'Mononoki_Nerd_Font_Complete_Mono_Regular.ttf', 10)
    love.graphics.setFont(font)
    love.graphics.setLineStyle( 'smooth' )
    love.graphics.setLineWidth( 0.25 )

end

function love.update(dt)
    updatePlanets(dt)
    if love.keyboard.isDown("down") then
        scale = scale - 0.01
    elseif love.keyboard.isDown("up") then
        scale = scale + 0.01
    end
    if scale < 0 then scale = 0.00001 end
end

function love.keyreleased( key )
    if key=='space' then
        trace = not trace
    elseif key=='kp8' then
        factor = factor + 0.001
        G = GConstant * factor -- adjustment for simulation to keep planets in orbit
        clearTails()
    elseif key=='kp2' then
        factor = factor - 0.001
        G = GConstant * factor -- adjustment for simulation to keep planets in orbit
        clearTails()
    elseif key=='escape' or key=='q' then
        love.event.quit()
    end
end

function love.mousereleased( x, y, button )
    w, h = x, y
end

function love.wheelmoved(x, y)
    if y > 0 then
        scale = scale + 0.05
    elseif y < 0 then
        scale = scale - 0.05
    end
    if scale < 0 then scale = 0.00001 end
end

function love.draw()
    love.graphics.setBackgroundColor({15/255, 15/255, 15/255})
    love.graphics.setColor({1,1,1})
    drawPlanets()
end
function love.resize()
   windowInit()
end


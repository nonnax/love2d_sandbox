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
    love.window.setTitle('Solar synchronicity dance - Randy Evangelista')
    love.window.setMode(800, 600, {resizable=true, vsync=0, minwidth=400, minheight=300})
    -- w, h = love.graphics.getDimensions()
    windowInit()
    w, h = 10, 10

    -- Define planets in our solar system with realistic initial conditions
    loadPlanets()

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
    elseif key=='kp+' or key=='=' then
        factor = factor + 0.001
        G = GConstant * factor -- adjustment for simulation to keep planets in orbit
        clearTails()
    elseif key=='kp-' or key=='-' then
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
    love.graphics.setColor(colors.white)
    drawPlanets()

    love.graphics.setColor(colors.white)
    love.graphics.print(string.format("SIM G^-2:%f x f:%f = %f", GConstant, factor, G), 10, Height - 50)
    love.graphics.print(string.format("f:% .4f*%.4f=%f",  GR, adjust, GR*adjust), 10, Height - 40)
    love.graphics.print(string.upper("mouse:center/zoom | space:R(on|off) | +/-:G(0.01) | esc:quit"), 10, Height - 20)
    love.graphics.print(string.upper("integration: symplectic Euler"), 10, Height - 30)
end
function love.resize()
   windowInit()
end


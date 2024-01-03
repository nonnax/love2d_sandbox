#!/usr/bin/env luvit
local sound = {}
function sound:load()
	self.explode = love.audio.newSource("Explosion.wav", "stream")
	self.explode:setVolume(0.3)

	self.explode2 = love.audio.newSource("Explosion2.wav", "stream")
	self.explode2:setVolume(0.3)

	self.laser = love.audio.newSource("Laser2.wav", "stream")
	self.laser:setVolume(0.3)

	music = love.audio.newSource("suspense.wav", "stream")
	music:setLooping(true)
	music:setVolume(0.2)
	music:play()

end

return sound

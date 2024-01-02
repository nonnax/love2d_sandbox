#!/usr/bin/env luvit
local sound = {}
function sound:load()
	self.explode = love.audio.newSource("Explosion.wav", "stream")
	self.explode:setVolume(0.3)

	self.laser = love.audio.newSource("Laser2.wav", "stream")
	self.laser:setVolume(0.3)
end

return sound

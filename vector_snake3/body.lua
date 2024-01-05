#!/usr/bin/env luvit

vector = require 'vector'

local function Body(x, y, r)
  local self = {}
  self.pos = vector(x or 10, y or 10)
  self.vel = vector.random() * 2
  self.vel:norm()

  self.initvel = self.vel:clone()
  self.radius = r or 1
  self.hitObject = nil
  self.dx = 0
  self.dy = 0
  self.tail = {}
  self.tailLenMax = 1

  function self.when_hit(object, cb)
    self.hit = vector.dist(self.pos, object.pos) < object.radius+self.radius
    if self.hit and cb then cb(object) end
    return self.hit
  end

  function self.when_tail_hit(tail, cb)
    for i, t in ipairs(tail) do
      self.hit=vector.dist(self.pos, t.pos) < t.radius+self.radius
      if self.hit and cb then cb(t, i) end
    end
    return self.hit
  end

  function self.grow(n)
    for i=1, n or 1 do
      local t={}
      t.pos=self.pos
      t.radius=self.radius
      self.tail[#self.tail+1] = t
    end
  end

  function self.shrink()
    table.remove(self.tail, 1)
  end

  return self
end

return Body

#!/usr/bin/env luvit
fn = require 'funcs'
local utf8 = require("utf8")
-- buffer as a array of strings
function Buffer(text)
 local self={}
 self.buffer={}
 self.text=""
 self.x=0
 self.y=0

 local function clamp_edges()
   if self.x < 0 then self.x = 0 end
   if self.x > self.text:len() then self.x = self.text:len() end
   if self.y < 0 then self.y = 0 end
   if self.y > #self.buffer then self.y = #self.buffer end
 end

 local function update()
   self.buffer[self.y]=self.text
   -- return self
 end

 -- append to buffer
 function self.append(text)
   self.text = text
   self.buffer[#self.buffer+1]=self.text
   self.y = #self.buffer
   self.x = self.text:len()
   return self
 end

 -- remove char at current row, col
 function self.remove()
   head, tail = fn.split_at(self.text, self.x)
   self.text = table.concat({head, tail})
   update()
   return self
 end

 function self.insert(ch)
   head, tail = fn.split_at(self.text, self.x)
   head = head..ch
   self.text = table.concat({head, tail})
   update()
   return self
 end

 function self.move(row, col)
   self.x = col
   self.y = row
   clamp_edges()
   return self
 end

 function self.up()
   self.y = self.y - 1
   clamp_edges()
   return self
 end

 function self.down()
  self.y = self.y + 1
  clamp_edges()
  return self
 end

 function self.left()
  self.x = self.x - 1
  clamp_edges()
  return self
 end

 function self.right()
  self.x = self.x + 1
  clamp_edges()
  return self
 end

 -- run matching keyboard key or return self if unhandled
 function self.key(fn)
  return self[fn] and self[fn]() or self
 end

 function self.loc()
  return self.x, self.y
 end

 return self

end

return Buffer

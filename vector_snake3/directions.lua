#!/usr/bin/env luvit
vector = require 'vector'

UP='up'
DOWN='down'
LEFT='left'
RIGHT='right'
STOP='stop'

function directions()
 local self = {}
 self.up={ x=0, y=-1 }
 self.down={ x=0, y=1 }
 self.right={ x=1, y=0 }
 self.left={ x=-1, y=0 }
 self.stop={ x=0, y=0 }
 self.heading = RIGHT

 self.inverter={}
 self.inverter.up=DOWN
 self.inverter.down=UP
 self.inverter.left=RIGHT
 self.inverter.right=LEFT
 self.inverter.stop=RIGHT

 function self.keypressed(key, cb)
     if ((key == UP)) then
       self.heading = UP
     end
     if ((key == DOWN)) then
       self.heading = DOWN
     end
     if ((key == LEFT)) then
       self.heading = LEFT
     end
     if ((key == RIGHT)) then
       self.heading = RIGHT
     end
     if ((key == STOP)) then
       self.heading = STOP
     end
     if cb then cb(key) end
     return self.heading
 end

 -- next step along current heading
 -- return a direction vector
 function self.move(dx)
   if dx and self[dx] then self.heading = dx end
   local d = self[self.heading]
   return vector(d.x, d.y)
 end
 -- alias
 self.update = self.move

 function self.bounce()
   self.heading=self.inverter[self.heading]
 end

 return self
end

return directions

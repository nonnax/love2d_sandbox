#!/usr/bin/env luvit
buf=require 'bufferdf'

b=buf()
p(b)

b.append("hello there")
b.append("how are you")
b.left()
b.left()
b.left()
b.insert('X')
p(b.left().insert('wala').text)
p(b.loc())
p(b.key('up').loc())
p(b.key('left').loc())
p(b.key('aleft'))



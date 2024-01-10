#!/usr/bin/env moon
-- Id$ nonnax Wed Jan 10 22:41:53 2024
-- https://github.com/nonnax
vector = require 'vector'

a = vector 100, 100

res = with a
       \rotate math.pi
       \setmag 200

print res\getmag!
print a\getmag!

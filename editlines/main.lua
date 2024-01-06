#!/usr/bin/env luvit
local utf8 = require("utf8")
tabler=require 'tabler'
require 'love/optimize'
fn=require 'funcs'

function love.load()
    buffer= buffer or {""} -- {text1, text2, text3}
    fname = 'filename.txt'
    read(fname)
    row = #buffer
    text = buffer[row] -- update current text buffer
    -- love.filesystem.setIdentity("data")
    font = love.graphics.newFont( 'Monaco-Bold.otf' )
    love.graphics.setFont(font)

    -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
    love.keyboard.setKeyRepeat(true)
    frames = 0
    lineheight = 20
    blink = true
    col = text:len()
end

function love.textinput(t)
   if col < text:len() then
    head, tail = fn.split_at(text, col)
    head = head..t
    text = table.concat({head, tail})
    col = col + 1
   else
    text = text .. t
    col = text:len()
   end

end

function love.keypressed(key)
    if key == "backspace" then
        if text:len()==0 then
            table.remove(buffer, row)
            row = row - 1
            if row < 1 then row = 1 end
            text=buffer[row]
        elseif col < text:len() then
            head, tail = fn.split_at(text, col)
            head = string.sub(head, 1, -2)
            text = table.concat({head, tail})
            -- col = head:len()
            col = col - 1
            if col < 1 then col=0 end
        else
            -- get the byte offset to the last UTF-8 character in the string.
            local byteoffset = utf8.offset(text, -1)

            if byteoffset then
                -- remove the last UTF-8 character.
                -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
                text = string.sub(text, 1, byteoffset - 1)
            end
        end
    elseif key == "left" then
        col = col - 1
        if col < 1 then col = 0 end
    elseif key == "right" then
        col = col + 1
        if col > text:len() then col = text:len() end
    elseif key == 'return' then
        buffer[row]=text
        if col == text:len() then
            row = row + 1
        end
        text=buffer[row] or ""
        col = text:len()
    end
end

function love.keyreleased(key)
    if key == "up" then
        row = row - 1
        if row < 1 then row = 1 end
        text=buffer[row]
        col = text:len()
    elseif key == "down" then
        row = row + 1
        if row > #buffer then row = #buffer end
        text=buffer[row]
        col = text:len()
    elseif key == "escape" then
      love.filesystem.write('filename.txt', table.concat(buffer, "\n"))
      love.event.quit()
    end
end

function magiclines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

function read(fname)
    buffer={}
    contents, size = love.filesystem.read('string', fname)
    contents = contents or ""
    for l in magiclines(contents) do
        buffer[#buffer+1]=l
    end
end

function love.update(dt)
    if frames % 20 == 0 then blink = not blink end
    frames = frames + 1
end

function love.draw()
    local cursorX = 7 * text:len() + 10

    love.graphics.circle('line', cursorX, 1, 3)
    love.graphics.printf(text, 10, row*lineheight, love.graphics.getWidth())
    for i, t in pairs(buffer) do
        if i ~= row then
            love.graphics.printf(t, 10, i*lineheight, love.graphics.getWidth())
        end
    end
    -- Display the cursor
    if blink then
       love.graphics.rectangle('fill', col*7+10, row*lineheight, 5, 15)
    end

    love.graphics.print(format("row:%d|col:%d", row, col), 10, Height-20)
end

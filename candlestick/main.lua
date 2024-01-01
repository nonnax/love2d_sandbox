#!/usr/bin/env luvit
s=require 'scaler'
tabler=require 'tabler'
json=require 'cjson'
filer=require 'filer'
pp=require 'pl.pretty'.dump

-- main.lua

-- Sample financial data
function generateSample(n)
    local stocks = {}
    for i=1, n do
        local row = {high = r(1150, 2000), low = r(550, 1190)}
        row.open = r(row.low, row.high)
        row.close = r(row.low, row.high)

        table.insert(stocks, row)
    end
    return stocks
end

-- take sample at index `from`, n-items
function take(data, from, n)
    local t={}
    for i=from, from+n do
        table.insert(t, data[i])
    end
    return t
end

function to_range(min_range, max_range)
    local range = max_range - min_range
    return function(numbers)
        local scaled_numbers = {}
        for _, number in ipairs(numbers) do
            local scaled_number = min_range + number * range
            table.insert(scaled_numbers, scaled_number)
        end
        return scaled_numbers
    end
end


r=math.random

function love.load()
    -- Set up Love2D window
    love.window.setTitle("Candlestick Plot")
    love.window.setMode(800, 600, {resizable = false})
    w, h = love.graphics.getDimensions()

    local sample =
    filer(arg[2] or 'shiba-inu_180.json')
    .read(json.decode)
    .map(function(rows)
        local r={}
        for i, row in ipairs(rows) do
           for k, v in pairs(row) do
               row[k]=tonumber(v)
           end
        end
        return rows
    end)
    .value


    -- local scaler = s(generateSample(300))
    local scaler = s(sample)
    -- scaleRows(canvasHeight, targetHeight)
    -- local pow = arg[3] and tonumber(arg[3])
    local pow = scaler:log10()
    stockData = scaler:scaleRows(h, h*5*10^pow)
    stockData2 = scaler:scaleRows(h, h*2*10^pow)
    -- local pow = math.ceil(math.log10(scaler:minY()))
    -- print(scaler:minY(), pow, scaler:minY()*(10*3))
    -- Set up the candlestick plot
    candleWidth = 3
    candleMargin = 5
    maxcandles = (w/(candleWidth+candleMargin))
    frames = 0
    i = 0
    financialData=take(stockData, 1, maxcandles)
    financialData2=take(stockData2, 1, maxcandles)
end

function love.update(dt)
    frames = frames + 1
    if frames % 25 == 0 then
        i = i % (#stockData-maxcandles) + 1
        financialData=take(stockData, i, maxcandles)
        financialData2=take(stockData2, i, maxcandles)
        -- print(i, #stockData-maxcandles, maxcandles, #stockData)
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1) -- Set color to white
    draw_candles(financialData, 10)
    draw_candles(financialData2, h/2)
end

function draw_candles(financialData, row)
    love.graphics.push()
    love.graphics.translate(0, row)

    for i, data in ipairs(financialData) do
        if data.close > data.open then
            love.graphics.setColor({1, 1, 1})
        else
            love.graphics.setColor({1, 0, 0})
        end
        local x = i * (candleWidth + candleMargin) -- Adjust spacing as needed

        -- Draw candle body
        love.graphics.rectangle("fill", x, data.open, candleWidth, data.close - data.open)

        -- Draw candle wick
        -- love.graphics.setColor({1, 1, 1})
        love.graphics.line(x + candleWidth / 2, data.high, x + candleWidth / 2, data.low)
        -- love.graphics.line(x + candleWidth / 2, data.high, x + candleWidth / 2, data.low)
    end

    love.graphics.pop()
end

#!/usr/bin/env luvit

-- Function to scale financial data points for candlestick chart in Love2D
tabler = require 'tabler'
local scaler = {}

function scaler:toDF(fx)
  local data = self
  local df = {}
  for i, row in ipairs(data) do
    for k, v in pairs(row) do
      if df[k] == nil then df[k] = {} end
      table.insert(df[k], v)
    end
  end

  if fx then for k, r in pairs(df) do df[k] = fx(r) end end

  return df
end

function scaler:toRows()
  local data = self
  local keys = tabler(data).keys()
  local rows = {}
  local nrows = #data[keys[1]]

  for i = 1, nrows do
    local row = {}
    for _, k in ipairs(keys) do
      -- collect all key/val for each row[i]
      row[k] = data[k][i]
    end
    table.insert(rows, row)
  end

  return rows
end

function scaler:minY()
  local t = self
  local arr = {}
  local df = self.toDF(t)
  for k, row in pairs(df) do for i, v in ipairs(row) do arr[#arr + 1] = v end end
  return math.min(unpack(arr))
end

function scaler:scaleY(canvasHeight, targetHeight)
  local minY = self:minY()
  local scale = targetHeight / canvasHeight
  return function(arr)
    local scaledArr = {}
    for i, value in ipairs(arr) do
      scaledArr[i] = (value - minY) * scale
    end
    return scaledArr
  end
end

function scaler.to_range(min_range, max_range)
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

function scaler:scaleRows(canvasHeight, targetHeight, fxscaler)
  local fx = self:scaleY(canvasHeight, targetHeight)
  if type(fxscaler) == 'function' then
    fx = fxscaler(canvasHeight, targetHeight)
  end
  return self.toRows(self:toDF(fx))
end

function scaler:log10()
  local pow = math.log10(self:minY())
  if math.floor(pow) < -0.00009 then
    pow = math.ceil(math.abs(pow)) + 1
  else
    pow = 0
  end
  return pow
end

scaler.__index = scaler
scaler.__call = function(_, ...) return setmetatable(..., scaler) end

return setmetatable({}, scaler)

local c = require("dynamic").palette
local bar = { fg = c.textVar, bg = "NONE" }
local function m() return { a = bar, b = bar, c = bar } end
return { normal = m(), insert = m(), visual = m(), replace = m(), command = m(), terminal = m(), inactive = m() }

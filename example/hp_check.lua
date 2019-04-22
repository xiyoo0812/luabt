local Luabt = require "source.luabt"

local mt = {}
mt.__index = mt

function mt:run(tick)
    if tick.robot.hp <= self.hp then
        return Luabt.SUCCESS
    else
        return Luabt.FAIL
    end
end

local function new(hp)
    local obj = {
        name = "hp_check",
        hp = hp,
    }
    setmetatable(obj, mt)
    return obj
end

return new

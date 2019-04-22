local Luabt = require "source.luabt"

local mt = {}
mt.__index = mt

function mt:open(tick)
    tick[self].tickNum = self.tickNum
    print(self.tickNum, "start flee....")
end

function mt:run(tick)
    local N = tick[self].tickNum - 1
    tick[self].tickNum = N
    if N == 0 then
        print(N, "finish flee")
        return Luabt.SUCCESS
    else
        print(N, "fleeing.......")
        return Luabt.RUNNING
    end
end

function mt:close(tick)
    print("close flee")
end

local function new(tickNum)
    local obj = {
        name = "flee",
        tickNum = tickNum,
    }
    setmetatable(obj, mt)
    return obj
end

return new

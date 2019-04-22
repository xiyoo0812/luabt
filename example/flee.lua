local Luabt = require "source.luabt"

local mt = {}
mt.__index = mt

function mt:open(bt)
    bt[self].tickNum = self.tickNum
    print(self.tickNum, "start flee....")
end

function mt:run(bt)
    local N = bt[self].tickNum - 1
    bt[self].tickNum = N
    if N == 0 then
        print(N, "finish flee")
        return Luabt.SUCCESS
    else
        print(N, "fleeing.......")
        return Luabt.RUNNING
    end
end

function mt:close(bt)
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

local Luabt = require "source.luabt"

local mt = {}
mt.__index = mt

function mt:open(tick)
    tick[self].tickNum = self.tickNum
    print(self.tickNum, "start attack...")
end

function mt:run(tick)
    local N = tick[self].tickNum - 1
    tick[self].tickNum = N
    if N == 0 then
        print(N, "attack finish!")
        return Luabt.SUCCESS
    else
        print(N, "attacking.....")
        return Luabt.RUNNING
    end
end

function mt:close(tick)
    print("close attack")
end


local function new(tickNum)
    local obj = {
        name = "attack",
        tickNum = tickNum
    }
    setmetatable(obj, mt)
    return obj
end

return new

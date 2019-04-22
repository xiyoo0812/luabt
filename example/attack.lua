local Luabt = require "source.luabt"

local mt = {}
mt.__index = mt

function mt:open(bt)
    bt[self].tickNum = self.tickNum
    print(self.tickNum, "start attack...")
end

function mt:run(bt)
    local N = bt[self].tickNum - 1
    bt[self].tickNum = N
    if N == 0 then
        print(N, "attack finish!")
        return Luabt.SUCCESS
    else
        print(N, "attacking.....")
        return Luabt.RUNNING
    end
end

function mt:close(bt)
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

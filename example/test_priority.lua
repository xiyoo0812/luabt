local Luabt     = require "script.include"
local Flee      = require "example.flee"
local Attack    = require "example.attack"
local HpCheck   = require "example.hp_check"

local Priority  = Luabt.Priority
local Sequence  = Luabt.Sequence

local robot = {id = 1, hp = 100}

local root = Priority(
    Sequence(
        HpCheck(50),
        Flee(5)
    ),
    Attack(20)
)

local bt = Luabt.new(robot, root)

-- print = function() end
for i = 1, 30 do
    print("================", i)
    if i == 10 then
        print(">>>>>>>> hp == 10")
        robot.hp = 10
    end
    if i == 18 then
        print(">>>>>>>> hp == 100")
        robot.hp = 100
    end
    bt:tick()
end

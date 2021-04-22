--hp_check.lua

local SUCCESS = luabt.SUCCESS
local RUNNING = luabt.RUNNING

local HpCheck = class()
function HpCheck:__init(hp)
    self.name = "hp_check"
    self.hp = hp
end

function HpCheck:run(tree)
    if tree.robot.hp <= self.hp then
        return SUCCESS
    else
        return FAIL
    end
end

return HpCheck

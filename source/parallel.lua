local Const = require "const"
local Node  = require "node"

local mt = {}
mt.__index = mt

-- luacheck: ignore 561
function mt:run(btree, data)
    local saw_success = false
    local saw_fail = false
    local saw_running = false
    local saw_all_fail = true
    local saw_all_success = true

    for _, node in ipairs(self.children) do
        local status = Node.execute(node, btree, data.__level + 1)
        if status == Const.FAIL then
            saw_fail = true
            saw_all_success = false
        elseif status == Const.SUCCESS then
            saw_success = true
            saw_all_fail = false
        else
            saw_running = true
            saw_all_fail = false
            saw_all_success = false
        end
    end

    local result = saw_running and Const.RUNNING or Const.FAIL

    if self.fail_policy == Const.FAIL_ALL and saw_all_fail or
       self.fail_policy == Const.FAIL_ONE and saw_fail then
        result = Const.FAIL
    elseif self.success_policy == Const.SUCCESS_ALL and saw_all_success or
       self.success_policy == Const.SUCCESS_ONE and saw_success then
       result = Const.SUCCESS
    end

    return result
end

function mt:close(btree)
    for _, node in ipairs(self.children) do
        local node_data = btree[node]
        if node_data and node_data.is_open then
            node_data.is_open = false
            if node.close then
                node:close(btree, node_data)
            end
        end
    end
end

-- 并行执行
local function new(fail_policy, success_policy, ...)
    assert(fail_policy == Const.FAIL_ALL or fail_policy == Const.FAIL_ONE)
    assert(success_policy == Const.SUCCESS_ALL or success_policy == Const.SUCCESS_ONE)
    local obj = {
        name = "parallel",
        fail_policy = fail_policy,
        success_policy = success_policy,
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new

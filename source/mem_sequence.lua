local Const = require "const"
local Node  = require "node"

local mt = {}
mt.__index = mt

function mt:open(_, node_data)
    node_data.runningChild = 1
end

function mt:run(btree, node_data)
    local child = node_data.runningChild
    for i = child, #self.children do
        local status = Node.execute(self.children[i], btree, node_data.__level + 1)
        if status == Const.FAIL then
            return status
        end
        if status == Const.RUNNING then
            node_data.runningChild = i
            return status
        end
    end
    return Const.SUCCESS
end

function mt:close(btree, node_data)
    node_data.runningChild = 1
    for _, node in ipairs(self.children) do
        local child_data = btree[node]
        if child_data and child_data.is_open then
            child_data.is_open = false
            if node.close then
                node:close(btree, child_data)
            end
        end
    end
end

local function new(...)
    local obj = {
        name = "mem_sequence",
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new

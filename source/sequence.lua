local Const = require "const"
local Node  = require "node"

local mt = {}
mt.__index = mt

function mt:run(btree, node_data)
    for _, node in ipairs(self.children) do
        local status = Node.execute(node, btree, node_data.__level + 1)
        if status ~= Const.SUCCESS then
            return status
        end
    end
    return Const.SUCCESS
end

function mt:close(btree)
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
        name = "sequence",
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new


local Const = require "const"
local Node  = require "node"

local mt = {}
mt.__index = mt

function mt:run(btree, node_data)
    if self.child then
        local status = Node.execute(self.child, btree, node_data.__level + 1)
        if status == Const.RUNNING then
            return status
        else
            return Const.SUCCESS
        end
    end
    return Const.SUCCESS
end

function mt:close(btree)
    if self.child then
        local node = self.child
        local node_data = btree[node]
        if node_data and node_data.is_open then
            node_data.is_open = false
            if node.close then
                node:close(btree, node_data)
            end
        end
    end
end

local function new(node)
    local obj = {
        name = "always_succeed",
        child = node,
    }
    setmetatable(obj, mt)
    return obj
end

return new

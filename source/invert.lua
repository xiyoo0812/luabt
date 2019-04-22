
local Const = require "const"
local Node  = require "node"

local mt = {}
mt.__index = mt

function mt:run(btree, node_data)
    local status = Node.execute(self.child, btree, node_data.__level + 1)
    if status == Const.RUNNING then
        return status
    elseif status == Const.SUCCESS then
        return Const.FAIL
    else
        return Const.SUCCESS
    end
end

function mt:close(btree)
    local node = self.child
    local node_data = btree[node]
    if node_data and node_data.is_open then
        node_data.is_open = false
        if node.close then
            node:close(btree, node_data)
        end
    end
end

local function new(node)
    local obj = {
        name = "invert",
        child = node,
    }
    setmetatable(obj, mt)
    return obj
end

return new

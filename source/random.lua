local Const = require "const"
local Node  = require "node"

local mt = {}
mt.__index = mt

function mt:open(_, node_data)
    node_data.runningChild = math.random(#self.children)
end

function mt:run(btree, node_data)    
    local child = node_data.runningChild
    local node = self.children[child]
    local status = Node.execute(node, btree, node_data.__level + 1)
    if status = Const.SUCCESS then
        return status
    end
    return Const.FAIL
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
        name = "random",
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new

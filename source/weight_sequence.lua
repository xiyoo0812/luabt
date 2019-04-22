local Const = require "const"
local Node  = require "node"

local mt = {}
mt.__index = mt

function mt:open(_, node_data)
    node_data.runningChild = 1
    if not node_data.indexes then
        local indexes = {}
        for i = 1, #self.children do
            table.insert(indexes, i)
        end
        node_data.indexes = indexes
    end
    Node.reorder(node_data.indexes, self.weight, self.total_weight)
end

function mt:run(btree, node_data)
    local child = node_data.runningChild
    for i = child, #node_data.indexes do
        local index = node_data.indexes[i]
        local status = Node.execute(self.children[index], btree, node_data.__level + 1)
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

local function new(weight, ...)
    assert(type(weight) == "table" and #weight == select("#", ...))
    local total_weight = 0
    for i = 1, #weight do
        total_weight = total_weight + weight[i]
    end
    local obj = {
        name = "weight_sequence",
        weight = weight,
        children = {...},
        total_weight = total_weight,
    }
    setmetatable(obj, mt)
    return obj
end

return new

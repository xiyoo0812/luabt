local Node  = require "node"
local Trace = require "trace"
local Const = require "const"

local M = {}

local mt = {}
mt.__index = mt

M.Succeed   = require("succeed")
M.Failed    = require("failed")
M.Invert    = require("invert")
M.Random    = require("random")
M.Priority  = require("priority")
M.Sequence  = require("sequence")
M.Parallel  = require("parallel")
M.SequenceM = require("mem_sequence")
M.PriorityM = require("mem_priority")
M.SequenceW = require("weight_sequence")
M.PriorityW = require("weight_priority")

function mt:tick()
    self.trace:clear()
    Node.execute(self.root, self, 0)
    -- close open nodes if necessary
    local openNodes = self.open_nodes
    local lastOpen = self.last_open
    for node in pairs(lastOpen) do
        local node_data = self[node]
        if not openNodes[node] and node_data.is_open then
            node_data.is_open = false
            if node.close then
                node:close(self, node_data)
            end
        end
        lastOpen[node] = nil
    end
    self.last_open = openNodes
    self.open_nodes = lastOpen  -- empty table
    self.frame = self.frame + 1
end

function mt:trace()
    self.trace:trace()
end

-- bt tree 实例：保存树的状态和黑板, [node] -> {is_open:boolean, ...}
-- @param robot     The robot to control
-- @param root      The behaviour tree root
-- @param log       [optional] the log function used to debug
function M.new(robot, root, log)
    local obj = {
        robot = robot,
        root = root,
        open_nodes = {},    -- 上一次 tick 运行中的节点
        last_open = {},
        frame = 0,          -- 帧数
        trace = Trace.create(log),
    }
    setmetatable(obj, mt)
    return obj
end

local mmt = {}
mmt.__index = Const
setmetatable(M, mmt)

return M

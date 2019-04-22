local mt = {}

local function st2str(status)
    if status == Const.SUCCESS then
        return "SUCCESS"
    elseif status == Const.FAIL then
        return "FAIL"
    else
        return "RUNNING"
    end
end

function mt:clear()
    if self.log then
        self.stack = {}
        self.nodes = {}
    end
end

function mt:trace()
    if self.log then
        for _, node in pairs(self.stack) do
            self.log("lua bt stack level:%d, node:%s, status:%s",
                node.level, node.node.name, node.status)
        end
    end
end

function mt:node_execute(bt, level, node)
    if not self.log then
        return
    end
    local node_info = {
        node = node,
        level = level,
    }
    table.insert(self.stack, node_info)
    self.nodes[node] = node_info
end

function mt:node_status(bt, node, status)
    if self.log then
        local node_info = self.nodes[node]
        if node_info then
            node_info.status = st2str(status)
        end
    end
end

local M = {}
function M.create(log)
    local o = {
        log = log,
        stack = {},
        nodes = {},
    }
    return setmetatable(o, {__index = mt})
end

return M


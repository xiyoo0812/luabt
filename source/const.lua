local mt = {}

mt.__index = function(_, n)
    error("invalid return value" .. n)
end

return setmetatable({
    -- Node Status
    SUCCESS = 1,
    FAIL    = 2,
    RUNNING = 3,

    -- Parallel Policy
    SUCCESS_ONE = 1,    -- success when one child success
    SUCCESS_ALL = 2,    -- success when all children success
    FAIL_ONE = 3,       -- fail when one child fail
    FAIL_ALL = 4,       -- fail when all children fail
}, mt)

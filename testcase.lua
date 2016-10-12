local mt = {
    __call = function(table, index)
        index = index or 1
        if index > #table then
            return
        end
        table[index](function() table(index+1) end)
    end
}

local Testcase = {}
Testcase.mt = {}
Testcase.step = {"setUp", "callInterface", "doCheck", "tearDown", "callb"}
Testcase.__setUp = setmetatable({}, mt)
Testcase.__callInterface = setmetatable({}, mt)
Testcase.__doCheck = setmetatable({}, mt)
Testcase.__tearDown = setmetatable({}, mt)

Testcase.mt.__index = function(table, key)
    return rawget(Testcase, key) or function()
        rawget(table, "__" + key)(function(index)
            table[table.step[index]](index)
        end)
    end
end

Testcase.mt.__call = function(table, index)
    index = index or 1
    table[table.step[index]]()
end

function Testcase:new(t)
    local testcase = {}
    setmetatable(testcase, self.mt)
    table.insert(t, testcase)
    return testcase
end

return Testcase

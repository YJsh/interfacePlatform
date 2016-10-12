local mt = {
    __call = function(table, index, callb)
        index = index or 1
        if index > #table then
            callb()
            return
        end
        table[index]()
        print(table.delay[index])
        table(index+1, callb)
    end
}

local Testcase = {}
Testcase.mt = {}
Testcase.step = {"setUp", "callInterface", "doCheck", "tearDown", "callb"}

Testcase.mt.__index = function(table, key)
    return rawget(Testcase, key) or function(callb)
        rawget(table, "__" .. key)(1, callb)
    end
end

Testcase.mt.__call = function(table, index, callb)
    if callb then
        table.callb = callb
    end
    index = index or 1
    if index == 1 then
        print(table.desc)
    end
    print("table call", index)
    if index > #table.step then
        return
    end
    table[table.step[index]](function() table(index+1) end)
end

function Testcase:new(t, desc)
    local testcase = {}
    testcase.desc = desc or ""
    setmetatable(testcase, self.mt)
    testcase.__setUp = setmetatable({}, mt)
    testcase.__callInterface = setmetatable({}, mt)
    testcase.__doCheck = setmetatable({}, mt)
    testcase.__tearDown = setmetatable({}, mt)
    testcase.callb = function() end
    table.insert(t, testcase)
    return testcase
end

function Testcase:__addFunc(key, func, delay)
    key = "__" .. key
    table.insert(self[key], func)
    self[key].delay = self[key].delay or {}
    table.insert(self[key].delay, delay or 0)
end

function Testcase:addSetUp(func, delay)
    self:__addFunc("setUp", func, delay)
end

function Testcase:addCallInterface(func, delay)
    self:__addFunc("callInterface", func, delay)
end

function Testcase:addDoCheck(func, delay)
    self:__addFunc("doCheck", func, delay)
end

function Testcase:addTearDown(func, delay)
    self:__addFunc("tearDown", func, delay)
end

return Testcase

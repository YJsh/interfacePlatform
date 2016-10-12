local Test = {}
Test.__call = function(table, index)
    index = index or 1
    if index > #table then
        return
    end
    table[index](1, function() table(index+1) end)
end

function Test:new()
    local test = {}
    setmetatable(test, self)
    return test
end

return Test

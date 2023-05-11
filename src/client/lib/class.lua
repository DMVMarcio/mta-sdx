local classes = {}

-- create a new class
function Class()
    local newClass = {}
    newClass.__index = newClass
    newClass.constructor = newClass
    classes[#classes+1] = newClass
    return newClass
end

-- create a new instance of a class
function New(target, ...)
    local instance = setmetatable({}, target)
    instance:constructor(...)
    return instance
end

function ClassExtends(target, base)
    -- TODO: Create a static classe and add methods to index into target class.
end

-- get all classes created
function getClassesCreated()
    return classes
end
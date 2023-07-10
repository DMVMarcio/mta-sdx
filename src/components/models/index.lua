SDX.components.models.base = { };

SDX.components.models.base.__index = SDX.components.models.base;

function SDX.components.models.base:getType()
    return self.type;
end

function SDX.components.models.base:setType(new_type)
    self.type = new_type;

    return self:getType();
end

function SDX.components.models.base:getParent()
    return self.parent;
end

function SDX.components.models.base:setParent(parent_instance)
    if(
        (not parent_instance)
        or (not SDX.components:has(parent_instance))
    ) then
        return false;
    end

    local lastParent = self:getParent();
    if(lastParent) then
        lastParent:removeChild(self);
    end

    self.parent = parent_instance;
    parent_instance:addChild(self);

    return self:getParent();
end

function SDX.components.models.base:getChilds(child_instance)
    return self.childs;
end

function SDX.components.models.base:addChild(child_instance)
    self.childs[child_instance] = true;

    return true;
end

function SDX.components.models.base:removeChild(child_instance)
    self.childs[child_instance] = nil;

    return true;
end

function SDX.components.models.base:drawSingle()
    return true;
end

function SDX.components.models.base:draw()
    self:drawSingle(data);

    for child in pairs(self:getChilds()) do
        child:draw();
    end
end

function SDX.components.models.base:onBeforeCreate()
    self.instances.event = SDX.utils.models.event:create();

    return true;
end

function SDX.components.models.base:onBeforeDestroy()
    return true;
end

function SDX.components.models.base:create(component_data)
    return SDX.components:create(component_data, self);
end

function SDX.components.models.base:destroy()
    return SDX.components:destroy(self);
end

SDX.utils.models.event:extends(SDX.components.models.base);

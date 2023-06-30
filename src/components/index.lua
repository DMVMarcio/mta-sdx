function SDX.components:has(component_instance)
    return self.list[component_instance];
end

function SDX.components:register(component_instance)
    if(not component_instance) then return false end;
    if(self:has(component_instance)) then return false end;

    self.list[component_instance] = true;

    return self:has(component_instance);
end

function SDX.components:unregister(component_instance)
    if(not component_instance) then return false end;

    self.list[component_instance] = nil;

    return (not self:has(component_instance));
end

function SDX.components:create(component_data, parent_instance)
    component_data = SDX.utils:prepareType(component_data, 'table', { });

    local componentInstance = {
        type = SDX.components.models[component_data.type] and component_data.type or 'base',
        parent = false,
        childs = { },
        instances = { }
    }

    componentInstance = setmetatable(componentInstance, {
        __index = SDX.components.models[componentInstance.type]
    });

    if(componentInstance.type ~= 'base') then
        SDX.components.models.base.onBeforeLoad(componentInstance, component_data);
    end

    componentInstance:onBeforeLoad(component_data);
    componentInstance:setParent(parent_instance);

    self:register(componentInstance);

    return componentInstance;
end

function SDX.components:destroy(component_instance)
    if(not component_instance) then return false end;

    for child_instance in pairs(component_instance:getChilds()) do
        component_instance:removeChild(child_instance);
        SDX.components:destroy(child_instance);
    end

    component_instance:onBeforeDestroy();

    self:unregister(component_instance);
    setmetatable(component_instance, nil);

    return (not self:has(component_instance));
end

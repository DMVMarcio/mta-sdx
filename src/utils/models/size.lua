SDX.utils.models.size = { };

SDX.utils.models.size.__index = SDX.utils.models.size;

function SDX.utils.models.size:create(component_data)
    local sizeInstance = setmetatable({
        transition = SDX.utils.models.transition:create({ })
    }, { __index = SDX.utils.models.size });

    sizeInstance:set({
        width = component_data.width,
        height = component_data.height
    }, false, true);

    return sizeInstance;
end

function SDX.utils.models.size:extends(target)
    target = SDX.utils:prepareType(target, 'table', { });

    function target:getSize(...)
        return self.instances.size:get(...);
    end

    function target:setSize(...)
        return self.instances.size:set(...);
    end

    function target:getWidth(...)
        return self.instances.size:getWidth(...);
    end

    function target:getHeight(...)
        return self.instances.size:getHeight(...);
    end

    return target;
end

function SDX.utils.models.size:get()
    local actual = self.transition:getActual();
    return { width = actual[1], height = actual[2] };
end

function SDX.utils.models.size:set(new_size, transition_data, first)
    local newSize = SDX.utils:prepareType(new_size, 'table', { });
    local lastSize = self.transition:getTo();

    newWidth = SDX.utils:prepareType(newSize.width, 'number', lastSize[1]);
    newHeight = SDX.utils:prepareType(newSize.height, 'number', lastSize[2]);

    if(transition_data) then
        self.transition:setData(transition_data, false);
    end

    self.transition:setTo({ newWidth, newHeight, 0 }, true, first);

    return true;
end

function SDX.utils.models.size:getWidth()
    return self:get().width;
end

function SDX.utils.models.size:getHeight()
    return self:get().height;
end

function SDX.utils.models.size:tick()
    return self.transition:tick();
end

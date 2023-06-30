SDX.utils.models.position = { };

SDX.utils.models.position.__index = SDX.utils.models.position;

function SDX.utils.models.position:create(component_data)
    local positionInstance = setmetatable({
        transition = SDX.utils.models.transition:create({ })
    }, { __index = SDX.utils.models.position });

    positionInstance:set(
        { x = component_data.x, y = component_data.y, z = component_data.z },
        false, true
    );

    return positionInstance;
end

function SDX.utils.models.position:extends(target)
    target = SDX.utils:prepareType(target, 'table', { });

    function target:getPosition(...)
        return self.instances.position:get(...);
    end

    function target:getPositionAbsolute(...)
        return self.instances.position:getAbsolute(self, ...);
    end

    function target:setPosition(...)
        return self.instances.position:set(...);
    end

    return target;
end

function SDX.utils.models.position:get()
    local actual = self.transition:getActual();
    return Vector3(actual);
end

function SDX.utils.models.position:getAbsolute(component_instance)
    if(
        (not component_instance)
        or (not component_instance.instances)
    ) then return false end;

    local parentInstance = component_instance:getParent();
    local parentPosition = parentInstance
        and (
            type(parentInstance.getPositionAbsolute) == 'function'
            and parentInstance:getPositionAbsolute()
            or Vector3(0, 0, 0)
        ) or Vector3(0, 0, 0);

    local relativePosition = component_instance:getPosition();

    return Vector3(
        parentPosition.x + relativePosition.x,
        parentPosition.y + relativePosition.y,
        parentPosition.z + relativePosition.z
    );
end

function SDX.utils.models.position:set(new_position, transition_data, first)
    local newPosition = SDX.utils:prepareType(new_position, 'table', { });

    local lastPosition = self.transition:getTo();

    newX = SDX.utils:prepareType(newPosition.x, 'number', lastPosition[1]);
    newY = SDX.utils:prepareType(newPosition.y, 'number', lastPosition[2]);
    newZ = SDX.utils:prepareType(newPosition.z, 'number', lastPosition[3]);

    if(transition_data) then
        self.transition:setData(transition_data, false);
    end

    self.transition:setTo({ newX, newY, newZ }, true, first);

    return true;
end

function SDX.utils.models.position:tick()
    return self.transition:tick();
end

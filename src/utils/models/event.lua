SDX.utils.models.event = { };

SDX.utils.models.event.__index = SDX.utils.models.event;

function SDX.utils.models.event:create(component_data)
    local eventInstance = setmetatable({
        listeners = { }
    }, { __index = SDX.utils.models.event });

    return eventInstance;
end

function SDX.utils.models.event:extends(target)
    target = SDX.utils:prepareType(target, 'table', { });

    function target:on(...)
        return self.instances.event:on(...);
    end

    function target:off(...)
        return self.instances.event:off(...);
    end

    function target:emit(...)
        return self.instances.event:emit(...);
    end

    return target;
end

function SDX.utils.models.event:on(event_name, event_callback)
    if(not self.listeners[event_name]) then
        self.listeners[event_name] = { };
    end

    self.listeners[event_name][event_callback] = event_callback;
    return true;
end

function SDX.utils.models.event:off(event_name, event_callback)
    if(not self.listeners[event_name]) then
        return true;
    end

    self.listeners[event_name][event_callback] = nil;
    return true;
end

function SDX.utils.models.event:emit(event_name, ...)
    if(not self.listeners[event_name]) then return true end;

    for event_callback in pairs(self.listeners[event_name]) do
        event_callback(...);
    end

    return true;
end

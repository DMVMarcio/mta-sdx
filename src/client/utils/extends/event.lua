function SDX.utils.extends:event(component)
    if(type(component) ~= 'table') then
        return false;
    end

    local events = {};

    function component:emit(event, data)
        data = data or {};
        if(not events[event]) then return end;

        for callback in pairs(events[event]) do
            callback(data);
        end
    end

    function component:destroyEvent(event, callback)
        if(not events[event]) then return end;

        events[event][callback] = nil;
    end

    function component:on(event, callback)
        if(not events[event]) then
            events[event] = {};
        end

        events[event][callback] = callback;
    end

    return component;
end

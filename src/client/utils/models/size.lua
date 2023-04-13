function SDX.utils.models:createSize(data, element)
    local size = { };
    local transition = SDX.utils.models:createTransition({ });

    function size:getSize()
        local from = transition:getFrom();
        return { w = from[1], h = from[2] };
    end

    function size:setSize(new_size, transition_data, first)
        local newSize = SDX.utils:typeOf(new_size, 'table', {});
        local lastSize = transition:getTo();

        newSizeW = SDX.utils:typeOf(newSize.w, 'number', lastSize[1]);
        newSizeH = SDX.utils:typeOf(newSize.h, 'number', lastSize[2]);

        if(transition_data) then
            transition:setData(transition_data, false);
        end
        transition:setTo({ newSizeW, newSizeH, 0 }, true, first);

        return true;
    end

    function size:getWidth()
        local from = transition:getFrom();
        return from[1];
    end

    function size:getHeight()
        local from = transition:getFrom();
        return from[2];
    end

    function size:tick()
        transition:tick();
    end

    if(element) then
        function element:getSize(...)
            return size:getSize(...);
        end

        function element:setSize(...)
            return size:setSize(...);
        end
    end

    size:setSize({ w = data.w, h = data.h }, false, true);

    return size;
end
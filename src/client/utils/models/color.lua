function SDX.utils.models:createColor(data, element)
    local color = { };
    local transitionColor = SDX.utils.models:createTransition({ });
    local transitionAlpha = SDX.utils.models:createTransition({ });

    function color:getColor()
        local colorFrom = transitionColor:getFrom();
        local alphaFrom = transitionAlpha:getFrom();

        return tocolor(colorFrom[1], colorFrom[2], colorFrom[3], alphaFrom[1]);
    end

    function color:setColor(color_data, transition_data, first)
        local new_color = SDX.utils:toColor(
            color_data,
            first and tocolor(255, 255, 255, 255) or color:getColor()
        );

        if(transition_data) then
            transitionColor:setData(transition_data, false);
            transitionAlpha:setData(transition_data, false);
        end
        transitionColor:setTo({ new_color[1], new_color[2], new_color[3] }, true, first);
        transitionAlpha:setTo({ new_color[4], 0, 0 }, true, first);

        return true;
    end

    function color:tick()
        transitionColor:tick();
        transitionAlpha:tick();
    end

    if(element) then
        function element:getColor(...)
            return color:getColor(...);
        end

        function element:setColor(...)
            return color:setColor(...);
        end
    end

    color:setColor(data.color, false, true);

    return color;
end

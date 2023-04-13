function SDX.utils.models:createPosition(data, element, extends)
    local position = { };
    local transition = SDX.utils.models:createTransition({ });

    function position:getPosition()
        local from = transition:getFrom();
        return { x = from[1], y = from[2], z = from[3] };
    end

    if(element) then
        function position:getPositionAbsolute()
            local parent = element:getParent();
            local parentPosition = parent
                and (
                    type(parent.getPositionAbsolute) == 'function'
                    and parent:getPositionAbsolute(true)
                    or { x = 0, y = 0, z = 0 }
                ) or { x = 0, y = 0, z = 0 };

            local lastPosition = self:getPosition();

            return {
                x = parentPosition.x + lastPosition.x,
                y = parentPosition.y + lastPosition.y,
                z = parentPosition.z + lastPosition.z
            }
        end
    end

    function position:setPosition(new_position, transition_data, first)
        local newPosition = SDX.utils:typeOf(new_position, 'table', {});

        local lastPosition = transition:getTo()

        newPositionX = SDX.utils:typeOf(newPosition.x, 'number', lastPosition[1]);
        newPositionY = SDX.utils:typeOf(newPosition.y, 'number', lastPosition[2]);
        newPositionZ = SDX.utils:typeOf(newPosition.z, 'number', lastPosition[3]);

        if(transition_data) then
            transition:setData(transition_data, false);
        end
        transition:setTo({ newPositionX, newPositionY, newPositionZ }, true, first);

        return true;
    end

    function position:tick()
        transition:tick();
    end

    if(element and extends) then
        function element:getPosition(...)
            return position:getPosition(...);
        end

        function element:getPositionAbsolute(...)
            return position:getPositionAbsolute(...);
        end

        function element:setPosition(...)
            return position:setPosition(...);
        end
    end

    position:setPosition({ x = data.x, y = data.y, z = data.z }, false, true);

    return position;
end

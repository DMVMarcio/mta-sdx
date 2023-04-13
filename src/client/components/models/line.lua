function SDX.components:createLine(data, parent)
    local component, private = SDX.components:create(data, 'line', parent);

    local startPositionSys = SDX.utils.models:createPosition(
        SDX.utils:typeOf(private.data.start, 'table', { }),
        component
    );
    local finishPositionSys = SDX.utils.models:createPosition(
        SDX.utils:typeOf(private.data.finish, 'table', { }),
        component
    );

    local sizeSys = SDX.utils.models:createSize(private.data, component);
    local colorSys = SDX.utils.models:createColor(private.data, component);
    local postGUISys = SDX.utils.models:createPostGUI(private.data, component);

    function component:getStartPosition(...)
        return startPositionSys:getPosition(...);
    end

    function component:getStartPositionAbsolute(...)
        return startPositionSys:getPositionAbsolute(...);
    end

    function component:setStartPosition(...)
        return startPositionSys:setPosition(...);
    end

    function component:getFinishPosition(...)
        return finishPositionSys:getPosition(...);
    end

    function component:getFinishPositionAbsolute(...)
        return finishPositionSys:getPositionAbsolute(...);
    end

    function component:setFinishPosition(...)
        return finishPositionSys:setPosition(...);
    end

    function component:drawSingle()
        startPositionSys:tick();
        finishPositionSys:tick();

        sizeSys:tick();
        colorSys:tick();

        local startAbsolutePos = self:getStartPositionAbsolute();
        local finishAbsolutePos = self:getFinishPositionAbsolute();

        local size = self:getSize();
        local color = self:getColor();

        dxDrawLine(
            startAbsolutePos.x, startAbsolutePos.y,
            finishAbsolutePos.x, finishAbsolutePos.y,
            color,
            size.w,
            self:getPostGUI()
        );
    end

    return component;
end

function SDX.components:createRectangle(data, parent)
    local component, private = SDX.components:create(data, 'rectangle', parent);

    local sizeSys = SDX.utils.models:createSize(private.data, component);
    local positionSys = SDX.utils.models:createPosition(private.data, component, true);
    local colorSys = SDX.utils.models:createColor(private.data, component);
    local postGUISys = SDX.utils.models:createPostGUI(private.data, component);

    function component:drawSingle()
        sizeSys:tick();
        positionSys:tick();
        colorSys:tick();

        local absolutePos = self:getPositionAbsolute();
        local size = self:getSize();
        local color = self:getColor();

        dxDrawRectangle(
            absolutePos.x, absolutePos.y,
            size.w, size.h,
            color,
            self:getPostGUI()
        );
    end

    return component;
end

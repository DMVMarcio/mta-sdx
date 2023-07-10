local imports = {
    tocolor = tocolor
};

SDX.utils.models.color = { };

SDX.utils.models.color.__index = SDX.utils.models.color;

function SDX.utils.models.color:create(component_data)
    local colorInstance = setmetatable({
        transitionColor = SDX.utils.models.transition:create({ }),
        transitionAlpha = SDX.utils.models.transition:create({ })
    }, { __index = SDX.utils.models.color });

    colorInstance:set(component_data.color, false, true);

    return colorInstance;
end

function SDX.utils.models.color:extends(target)
    target = SDX.utils:prepareType(target, 'table', { });

    function target:getColor(...)
        return self.instances.color:get(...);
    end

    function target:setColor(...)
        return self.instances.color:set(...);
    end

    return target;
end

function SDX.utils.models.color:get()
    local colorActual = self.transitionColor:getActual();
    local alphaActual = self.transitionAlpha:getActual();

    return imports.tocolor(colorActual[1], colorActual[2], colorActual[3], alphaActual[1]);
end

function SDX.utils.models.color:set(color_data, transition_data, first)
    local new_color = SDX.utils:prepareColor(
        color_data,
        first and imports.tocolor(255, 255, 255, 255) or self:get()
    );

    if(transition_data) then
        self.transitionColor:setData(transition_data, false);
        self.transitionAlpha:setData(transition_data, false);
    end

    self.transitionColor:setTo({ new_color[1], new_color[2], new_color[3] }, true, first);
    self.transitionAlpha:setTo({ new_color[4], 0, 0 }, true, first);

    return true;
end

function SDX.utils.models.color:tick()
    self.transitionColor:tick();
    self.transitionAlpha:tick();
end

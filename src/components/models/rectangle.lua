SDX.components.models.rectangle = { };

function SDX.components.models.rectangle:onBeforeLoad(component_data)
    self.instances.position = SDX.utils.models.position:create(component_data);
    self.instances.size = SDX.utils.models.size:create(component_data);
    self.instances.color = SDX.utils.models.color:create(component_data);

    return true;
end

function SDX.components.models.rectangle:drawSingle()
    self.instances.position:tick();
    self.instances.size:tick();
    self.instances.color:tick();

    local position = self:getPositionAbsolute();
    local size = self:getSize();
    local color = self:getColor();

    dxDrawRectangle(
        position.x, position.y,
        size.width, size.height,
        color
    );
end

SDX.utils.models.position:extends(SDX.components.models.rectangle);
SDX.utils.models.size:extends(SDX.components.models.rectangle);
SDX.utils.models.color:extends(SDX.components.models.rectangle);

setmetatable(SDX.components.models.rectangle, { __index = SDX.components.models.base });

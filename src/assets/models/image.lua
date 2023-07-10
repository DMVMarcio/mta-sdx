local imports = {
    isElement = isElement,
    getElementType = getElementType
}

SDX.assets.models.image = { };

SDX.assets.models.image.__index = SDX.assets.models.image;

function SDX.assets.models.image:get()
    return self.src;
end

function SDX.assets.models.image:set(image_data)
    local actualSrc = self:get();

    if(not image_data.src) then
        self.src = false;
        return true;
    end

    if(imports.isElement(image_data.src)) then
        if(imports.getElementType(image_data.src) ~= 'texture') then return false end;

        self.src = image_data.src;
        return true;
    end

    self.src = type(image_data.src) == 'string' and image_data.src or actualSrc;
    return (not (not type(image_data.src) == 'string'));
end

function SDX.assets.models.image:onBeforeCreate(asset_data)
    self.src = false;

    self:set(asset_data);

    return true;
end

function SDX.assets.models.image:onBeforeDestroy()

    return true;
end

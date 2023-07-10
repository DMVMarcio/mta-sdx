local imports = {
    dxCreateTexture = dxCreateTexture,

    isElement = isElement,
    destroyElement = destroyElement,
    getElementType = getElementType
}

SDX.assets.models.texture = { };

SDX.assets.models.texture.__index = SDX.assets.models.texture;

function SDX.assets.models.texture:get()
    return self.texture;
end

function SDX.assets.models.texture:set(texture_data, ...)
    local actualTexture = self:get();

    if(texture_data == false) then
        if(imports.isElement(actualTexture)) then
            imports.destroyElement(actualTexture);
        end

        self.texture = false;
        return true;
    end

    if(imports.isElement(texture_data)) then
        if(imports.getElementType(texture_data) ~= 'texture') then return false end;

        self.texture = texture_data;
        return true;
    end

    local createdTexture = imports.dxCreateTexture(texture_data, ...);
    self.texture = createdTexture and createdTexture or actualTexture;
    return (not (not createdTexture));
end

function SDX.assets.models.texture:onBeforeCreate(asset_data)
    self:set(false);

    return true;
end

function SDX.assets.models.texture:onBeforeDestroy()
    self:set(false);

    return true;
end

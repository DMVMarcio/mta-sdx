function SDX.assets:has(asset_instance)
    return self.list[asset_instance];
end

function SDX.assets:register(asset_instance)
    if(not asset_instance) then return false end;
    if(self:has(asset_instance)) then return false end;

    self.list[asset_instance] = true;

    return self:has(asset_instance);
end

function SDX.assets:unregister(asset_instance)
    if(not asset_instance) then return false end;

    self.list[asset_instance] = nil;

    return (not self:has(asset_instance));
end

function SDX.assets:create(asset_data)
    asset_data = SDX.utils:prepareType(asset_data, 'table', { });

    local assetInstance = {
        type = SDX.asset.models[asset_data.type] and asset_data.type or 'base',
        dependents = { }
    }

    assetInstance = setmetatable(assetInstance, {
        __index = SDX.asset.models[assetInstance.type]
    });

    if(assetInstance.type ~= 'base') then
        SDX.asset.models.base.onBeforeLoad(assetInstance, asset_data);
    end

    assetInstance:onBeforeLoad(asset_data);

    self:register(assetInstance);

    return assetInstance;
end

function SDX.assets:destroy(asset_instance)
    if(not asset_instance) then return false end;

    asset_instance:onBeforeDestroy();

    self:unregister(asset_instance);
    setmetatable(asset_instance, nil);

    return (not self:has(asset_instance));
end

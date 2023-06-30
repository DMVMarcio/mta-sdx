SDX.assets.models.base = { };

SDX.assets.models.base.__index = SDX.assets.models.base;

function SDX.assets.models.base:getType()
    return self.type;
end

function SDX.assets.models.base:setType(new_type)
    self.type = new_type;

    return self:getType();
end

function SDX.assets.models.base:getDependents(dependent_instance)
    return self.dependents;
end

function SDX.assets.models.base:addDependent(dependent_instance)
    self.dependents[dependent_instance] = true;

    return true;
end

function SDX.assets.models.base:removeDependent(dependent_instance)
    self.dependents[dependent_instance] = nil;

    return true;
end

function SDX.assets.models.base:onBeforeLoad()
    return true;
end

function SDX.assets.models.base:onBeforeDestroy()
    return true;
end

function SDX.assets.models.base:destroy()
    return SDX.assets:destroy(self);
end

local imports = {
    type = type,
    pairs = pairs
}

function SDX.components:get(component_id)
    return SDX.components.list[component_id] or false;
end

function SDX.components:create(data, component_type, parent)
    data = SDX.utils:typeOf(data, 'table', { });

    local component = { };
    local private = {
        id = nil,
        type = component_type or 'base',
        parent = nil,
        childs = { },
        auto_draw = true,
        data = data
    }

    private.id = SDX.utils:getFreeId('component-' .. private.type);

    SDX.utils.extends:event(component);

    function component:getID()
        return private.id;
    end

    function component:getType()
        return private.type;
    end

    function component:getParent()
        return self:hasParent() and SDX.components:get(private.parent) or false;
    end

    function component:hasParent()
        return private.parent ~= nil;
    end

    function component:setParent(parent_component)
        if(
            (not parent_component)
            or (imports.type(parent_component.getID) ~= 'function')
            or (not SDX.components:get(parent_component:getID()))
        ) then
            private.parent = nil;
            return nil;
        end

        local lastParent = self:getParent();
        if(lastParent) then
            lastParent:removeChild(self);
        end

        private.parent = parent_component:getID();
        parent_component:addChild(self);

        return self:getParent();
    end

    function component:getChild(child_id)
        return SDX.components:get(child_id);
    end

    function component:getChilds(child_callback)
        local childList = {};

        for child_id in imports.pairs(private.childs) do
            local child = self:getChild(child_id);

            if(child) then
                if(child_callback) then
                    child_callback(child);
                end

                childList[#childList + 1] = child;
            end
        end

        return childList;
    end

    function component:addChild(child_component)
        private.childs[child_component:getID()] = true;
    end

    function component:removeChild(child_component)
        private.childs[child_component:getID()] = nil;
    end

    function component:refreshSingle()
        return false;
    end

    function component:refresh()
        self:refreshSingle();
        local parent = self:getParent();

        if(parent) then
            parent:refresh();
        end
    end

    function component:drawSingle(data)
        return false;
    end

    function component:draw(data)
        self:drawSingle(data);

        self:getChilds(function(child)
            child:draw(data);
        end);
    end

    component:setParent(parent);

    SDX.components.list[component:getID()] = component;
    return component, private;
end

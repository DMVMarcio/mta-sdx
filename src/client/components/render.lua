function SDX.components:render()
    for _, component in pairs(SDX.components.list) do
        if(not component:hasParent()) then
            component:draw();
        end
    end
end

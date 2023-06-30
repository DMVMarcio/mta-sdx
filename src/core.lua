SDX = {
    components = {
        list = { },
        models = { }
    },
    assets = {
        list = { },
        models = { }
    },
    utils = {
        models = { }
    }
};

addEventHandler('onClientRender', root, function()
    for component in pairs(SDX.components.list) do
        if(not component:getParent()) then
            component:draw();
        end
    end
end);

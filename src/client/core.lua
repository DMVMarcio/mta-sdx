local imports = {
    guiGetScreenSize = guiGetScreenSize,

    addEventHandler = addEventHandler
}

local screenSize = { imports.guiGetScreenSize() };

SDX = {
    screen = { w = screenSize[1], h = screenSize[2], rendering = false },
    components = {
        list = { }
    },
    elements = {
        list = { }
    },
    utils = {
        models = { },
        extends = { }
    }
};

function SDX.screen:render()
    SDX.components:render();
end

imports.addEventHandler('onClientRender', root, SDX.screen.render);

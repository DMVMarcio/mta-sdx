function SDX.screen:render()
    SDX.components:render();
end

addEventHandler('onClientRender', root, SDX.screen.render);

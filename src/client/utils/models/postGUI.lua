function SDX.utils.models:createPostGUI(data, element)
    local postGUI = { };
    local private = {
        enabled = false
    };

    function postGUI:getState()
        return private.enabled;
    end

    function postGUI:setState(new_state)
        private.enabled = new_state and true or false;

        if(element) then
            element:refresh();
        end

        return true;
    end

    if(element) then
        function element:getPostGUI(...)
            return postGUI:getState(...);
        end

        function element:setPostGUI(...)
            return postGUI:setState(...);
        end
    end

    postGUI:setState(data.postGUI);

    return postGUI;
end

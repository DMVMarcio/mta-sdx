local lists = {};

function SDX.utils:getFreeId(list_name)
    if(not lists[list_name]) then
        lists[list_name] = -1;
    end

    local freeId = lists[list_name] + 1;
    lists[list_name] = lists[list_name] + 1;

    return list_name .. '-' .. freeId;
end

function SDX.utils:typeOf(value, type_value, default_value)
    return type(value) == type_value and value or default_value;
end

function SDX.utils:clamp(value, min, max)
    if(min ~= false and min ~= nil) then
        value = value < min and min or value;
    end

    if(max ~= false and min ~= nil) then
        value = value > max and max or value;
    end

    return value or 0;
end

function SDX.utils:toColor(color_data, default_color)
    local defaultColor = default_color and SDX.utils:toColor(default_color) or { 255, 255, 255, 255 };

    local function prepareColor(value) 
        return self:clamp(self:typeOf(value, 'number', 255), 0, 255);
    end

    if(type(color_data) == 'number') then
		return {
            prepareColor(bitExtract(color_data, 16, 8)),
            prepareColor(bitExtract(color_data, 8, 8)),
            prepareColor(bitExtract(color_data, 0, 8)),
            prepareColor(bitExtract(color_data, 24, 8))
        };
    elseif(type(color_data) == 'string') then
        local color = { getColorFromString(color_data) };
        color = color[1] ~= false and {
            color[1], color[2], color[3], color[4]
        } or defaultColor;

        return color;
    elseif(type(color_data) == 'table') then
        local color = {
            prepareColor(color_data[1]),
            prepareColor(color_data[2]),
            prepareColor(color_data[3]),
            prepareColor(color_data[4])
        };

        return color;
    end

    return defaultColor;
end

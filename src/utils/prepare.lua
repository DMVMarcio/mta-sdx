local imports = {
    bitExtract = bitExtract,
    getColorFromString = getColorFromString
};

function SDX.utils:prepareType(value, value_type, default_value)
    return type(value) == value_type and value or default_value;
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

function SDX.utils:prepareColor(color_data, default_color)
    local defaultColor = default_color and self:prepareColor(default_color) or { 255, 255, 255, 255 };

    if(type(color_data) == 'number') then
		return {
            imports.bitExtract(color_data, 16, 8),
            imports.bitExtract(color_data, 8, 8),
            imports.bitExtract(color_data, 0, 8),
            imports.bitExtract(color_data, 24, 8)
        };
    elseif(type(color_data) == 'string') then
        local color = { imports.getColorFromString(color_data) };
        color = color[1] ~= false and {
            color[1], color[2], color[3], color[4]
        } or defaultColor;

        return color;
    elseif(type(color_data) == 'table') then
        local color = {
            self:clamp(self:prepareType(color_data[1], 'number', 255), 0, 255),
            self:clamp(self:prepareType(color_data[2], 'number', 255), 0, 255),
            self:clamp(self:prepareType(color_data[3], 'number', 255), 0, 255),
            self:clamp(self:prepareType(color_data[4], 'number', 255), 0, 255)
        };

        return color;
    end

    return defaultColor;
end

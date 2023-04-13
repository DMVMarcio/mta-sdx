local rectangle = SDX.components:createRectangle({
    x = 50,
    y = 200,
    w = 200,
    h = 200,
    color = '#FF7600'
});

local child = SDX.components:createRectangle({
    x = 50,
    y = 50,
    w = 100,
    h = 100,
    color = tocolor(255, 0, 255, 255)
}, rectangle);

setTimer(function()
    rectangle:setSize({ w = 400 }, { duration = 3 });
    rectangle:setColor(tocolor(0, 255, 255), { duration = 3 });
end, 3000, 1);

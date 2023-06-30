local validAnimations = {
    ['Linear'] = true, ['InQuad'] = true,
    ['OutQuad'] = true, ['InOutQuad'] = true,
    ['OutInQuad'] = true, ['InElastic'] = true,
    ['OutElastic'] = true, ['InOutElastic'] = true,
    ['OutInElastic'] = true, ['InBack'] = true,
    ['OutBack'] = true, ['InOutBack'] = true,
    ['OutInBack'] = true, ['InBounce'] = true,
    ['OutBounce'] = true, ['InOutBounce'] = true,
    ['OutInBounce'] = true, ['SineCurve'] = true,
    ['CosineCurve'] = true
};

SDX.utils.models.transition = { };

SDX.utils.models.transition.__index = SDX.utils.models.transition;

function SDX.utils.models.transition:create(transition_data)
    local transitionInstance = setmetatable({
        actual = { 0, 0, 0 },
        from = { 0, 0, 0 },
        to = { 0, 0, 0 },
        duration = 0,
        type = 'Linear',
        callback = false,
        first_setter = true,
        start_tick = 0,
        running = true
    }, { __index = SDX.utils.models.transition });

    transitionInstance:setData(transition_data, false);

    return transitionInstance;
end

function SDX.utils.models.transition:setData(data, needs_refresh)
    data = SDX.utils:prepareType(data, 'table', { });

    self:setFrom(data.from);

    self:setTo(data.to);
    self:setDuration(data.duration);
    self:setType(data.type);
    self:setCallback(data.callback);

    if(needs_refresh) then
        self:refresh();
    end

    return true;
end

function SDX.utils.models.transition:getActual()
    return self.actual;
end

function SDX.utils.models.transition:setActual(actual_data)
    self.actual = actual_data;

    return self:getActual();
end

function SDX.utils.models.transition:getFrom()
    return self.from;
end

function SDX.utils.models.transition:setFrom(from_data, needs_refresh)
    from_data = SDX.utils:prepareType(from_data, 'table', self:getActual());

    local newFrom = self:getFrom();
    for from_i = 1, 3 do
        newFrom[from_i] = SDX.utils:prepareType(from_data[from_i], 'number', newFrom[from_i]);
    end

    self.from = newFrom;
    self:setActual(newFrom);

    if(needs_refresh) then
        self:refresh();
    end

    return true;
end

function SDX.utils.models.transition:getTo()
    return self.to;
end

function SDX.utils.models.transition:setTo(to_data, needs_refresh, update_from)
    to_data = SDX.utils:prepareType(to_data, 'table', { });

    local newTo = self:getTo();
    for to_i = 1, 3 do
        newTo[to_i] = SDX.utils:prepareType(to_data[to_i], 'number', newTo[to_i]);
    end

    self.to = newTo;

    if(update_from) then
        self:setFrom(self:getTo());
    end

    if(needs_refresh) then
        self:refresh();
    end

    return true;
end

function SDX.utils.models.transition:getDuration()
    return self.duration;
end

function SDX.utils.models.transition:setDuration(new_duration, needs_refresh)
    new_duration = SDX.utils:prepareType(new_duration, 'number', 0);
    new_duration = new_duration < 0 and 0 or new_duration;

    self.duration = new_duration * 1000;
    if(needs_refresh) then
        self:refresh();
    end

    return true;
end

function SDX.utils.models.transition:getType()
    return self.type;
end

function SDX.utils.models.transition:setType(new_type, needs_refresh)
    new_type = SDX.utils:prepareType(new_type, 'string', 'Linear');

    if(not validAnimations[new_type]) then return false end;

    self.type = new_type;
    if(needs_refresh) then
        self:refresh();
    end

    return true;
end

function SDX.utils.models.transition:isRunning()
    return self.running;
end

function SDX.utils.models.transition:setRunning(new_state)
    self.running = not (not new_state);

    return true;
end

function SDX.utils.models.transition:getCallback()
    return self.callback;
end

function SDX.utils.models.transition:setCallback(new_callback, needs_refresh)
    new_callback = SDX.utils:prepareType(new_callback, 'function', nil);

    self.callback = new_callback;
    if(needs_refresh) then
        self:refresh();
    end

    return true;
end

function SDX.utils.models.transition:getStartTick()
    return self.start_tick;
end

function SDX.utils.models.transition:setStartTick(new_tick)
    self.start_tick = SDX.utils:prepareType(new_tick, 'number', getTickCount());

    return true;
end

function SDX.utils.models.transition:refresh()
    self.start_tick = getTickCount();
    self:setRunning(true);
end

function SDX.utils.models.transition:getElapsed()
    return getTickCount() - self:getStartTick();
end

function SDX.utils.models.transition:getProgress()
    local progress = self:getElapsed() / self:getDuration();

    return (progress ~= math.huge and progress == progress) and progress or 1;
end

function SDX.utils.models.transition:isEnded()
    return self:getProgress() >= 1;
end

function SDX.utils.models.transition:tick()
    if(self:isRunning()) then
        local from = self:getFrom();
        local to = self:getTo();

        local interpolateRes = {
            interpolateBetween(
                from[1],
                from[2],
                from[3],
                to[1],
                to[2],
                to[3],
                self:getProgress(),
                self:getType()
            )
        };

        self:setActual(interpolateRes, false);

        if(self:isEnded()) then
            self:setRunning(false);

            self:setDuration(0);
            self:setType('Linear');

            local callback = self:getCallback();
            if(callback) then
                self:setCallback(nil);
                callback();
            end
        end
    end
end

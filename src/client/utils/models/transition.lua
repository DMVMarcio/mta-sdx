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

function SDX.utils.models:createTransition(data, element)
    local transition = { };
    local private = {
        from = { 0, 0, 0 },
        to = { 0, 0, 0 },
        duration = 0,
        type = 'Linear',
        callback = nil,
        first_setter = true,
        start_tick = 0,
        running = true
    };

    function transition:setData(data, needs_refresh)
        data = SDX.utils:typeOf(data, 'table', { });

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

    function transition:getFrom()
        return private.from;
    end

    function transition:getTo()
        return private.to;
    end

    function transition:isEnded()
        local from = self:getFrom();
        local to = self:getTo();

        if(
            (from[1] ~= to[1])
            or (from[2] ~= to[2])
            or (from[3] ~= to[3])
        ) then
            return false;
        end

        return true;
    end

    function transition:setFrom(from_data, needs_refresh)
        from_data = SDX.utils:typeOf(from_data, 'table', { });

        local newFrom = self:getFrom();
        for from_i = 1, 3 do
            newFrom[from_i] = SDX.utils:typeOf(from_data[from_i], 'number', newFrom[from_i]);
        end

        private.from = newFrom;
        if(needs_refresh) then
            self:refresh();
        end

        return true;
    end

    function transition:setTo(to_data, needs_refresh, update_from)
        to_data = SDX.utils:typeOf(to_data, 'table', { });

        local newTo = self:getTo();
        for to_i = 1, 3 do
            newTo[to_i] = SDX.utils:typeOf(to_data[to_i], 'number', newTo[to_i]);
        end

        private.to = newTo;

        if(update_from) then
            self:setFrom(self:getTo());
        end

        if(needs_refresh) then
            self:refresh();
        end

        return true;
    end

    function transition:getDuration()
        return private.duration;
    end

    function transition:setDuration(new_duration, needs_refresh)
        new_duration = SDX.utils:typeOf(new_duration, 'number', 0);
        new_duration = new_duration < 0 and 0 or new_duration;

        private.duration = new_duration * 1000;
        if(needs_refresh) then
            self:refresh();
        end

        return true;
    end

    function transition:getType()
        return private.type;
    end

    function transition:setType(new_type, needs_refresh)
        new_type = SDX.utils:typeOf(new_type, 'string', 'Linear');

        local isValid = validAnimations[new_type];
        if(not isValid) then
            return false;
        end

        private.type = new_type;
        if(needs_refresh) then
            self:refresh();
        end

        return true;
    end

    function transition:isRunning()
        return private.running;
    end

    function transition:setRunning(new_state)
        private.running = new_state and true or false;
        return true;
    end

    function transition:getCallback()
        return private.callback;
    end

    function transition:setCallback(new_callback, needs_refresh)
        new_callback = SDX.utils:typeOf(new_callback, 'function', nil);

        private.callback = new_callback;
        if(needs_refresh) then
            self:refresh();
        end

        return true;
    end

    function transition:getStartTick()
        return private.start_tick;
    end

    function transition:refresh()
        private.start_tick = getTickCount();
        self:setRunning(true);
    end

    function transition:getElapsed()
        return getTickCount() - self:getStartTick();
    end

    function transition:getProgress()
        local progress = self:getElapsed() / self:getDuration();

        return (progress ~= math.huge and progress == progress) and progress or 1;
    end

    function transition:tick()
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

            self:setFrom(interpolateRes, false);

            if(element) then
                element:refresh();
            end

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

    transition:setData(data, false);
    return transition;
end

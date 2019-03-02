local eventManager = {};

function eventManager.addEventListener(eventName, callback)
	if type(eventName) ~= "string" then
		error(tostring(eventName).." is not a valid event name!", 2);
	end;
	local event = eventManager[eventName];
	if not event then
		event = {callback};
		eventManager[eventName] = event; --create new event
	else
		eventManager[eventName][#event] = callback; --add new callback to existing event
	end;
end;

function eventManager.triggerEvent(eventName, ...)
	local event = eventManager[eventName];
	if event then
		for _, callback in pairs(event) do
			callback(...);
		end;
	end;
end;


return eventManager;
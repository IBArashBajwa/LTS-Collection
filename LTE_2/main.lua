local editor = require("editor");

local function reportErrorMessage(message)
	if type(message) ~= "string" then
		print("arg #1 string expected, got "..type(message), 2);
		return function() end;
	end;
	
	local window = nil;
	if window == nil then
		local errorFile = io.open("LTE Failed To Open.txt", "w+");
		if errorFile == nil then
			print("Can't open file");
		end;
		errorFile:write(message);
		errorFile:close();
		return function() end;
	end;
	
	window.showMessageBox("LTE failed to start!", message, "error");
	window.close();
	
	return function() end;
end;

function love.run() 
	--Optmized and specialized version of the default run function,
	--It can be found here: https://love2d.org/wiki/love.run
	
	local timer		= love.timer;
	local event		= love.event;
	local graphics	= love.graphics;
	
	if not timer then
		return reportErrorMessage("Failed to get timer.");
	elseif not event then
		return reportErrorMessage("Failed to get event.");
	elseif not graphics then
		return reportErrorMessage("Failed to get graphics.");
	end;
	
	
	love.handlers = nil;
	
	
	editor.load();
	
	local eventPump			= event.pump;
	local eventPoll 		= event.poll;
	local timerStep 		= timer.step;
	local editorUpdate		= editor.update;
	--local newEventsPolled	= true;
	local graphicsIsActive	= graphics.isActive;
	local graphicsOrigin	= graphics.origin;
	local graphicsClear		= graphics.clear;
	local clearColor		= require("editor_resources").COLORS.EDITOR_BACKGROUND;
	local editorDraw		= editor.draw;
	local graphicsPresent	= graphics.present;
	local timerSleep		= timer.sleep;
	local editorFPSSleep	= 1/(editor.getFPS() or 10);
	local windowFocused		= false;
	
	local function normalPerformanceMainLoop()
		editorUpdate(
			timerStep()
		);
		
		if --[[newEventsPolled and ]] graphicsIsActive() then
			graphicsOrigin();
			graphicsClear(clearColor);
			
			editorDraw();
			
			graphicsPresent();
		end;
		
		timerSleep(editorFPSSleep);
	end;
	
	local function lowPerformanceMainLoop()
		timerSleep(editorFPSSleep);
	end;
	
	local currentMainLoop = normalPerformanceMainLoop;
	
	timerStep();
	
	
	return function()
		eventPump();
		for name, a, b, c, d in eventPoll() do
		--	newEventsPolled = true;
			if name == "quit" then
				editor.quit();
			elseif name == "focus" then
				if a then --If window is focused, then keep performance normal
					currentMainLoop = normalPerformanceMainLoop;
				else		--else decrease toll on CPU & GPU
					currentMainLoop = lowPerformanceMainLoop;
				end;
			elseif name == "resize" then
				editor.resize(a, b);
			elseif name == "mousepressed" then
				editor.mousepressed(a, b);
			elseif name == "mousemoved" then
				editor.mousemoved(a, b, c, d);
			elseif name == "mousereleased" then
				editor.mousereleased(a, b);
			elseif name == "keypressed" then
				editor.keypressed(a, b, c);
			elseif name == "textinput" then
				editor.textinput(a);
			end;
			--love.handlers[name](a,b,c,d,e,f)
		end;
		
		currentMainLoop();
		
	--	newEventsPolled = false;
	end;
end;
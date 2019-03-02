function love.conf(t)
	t.console = true;
	
	t.window.width = 600;
	t.window.height = 400;
	t.window.minwidth = 400;
	t.window.minheight = 200;
	t.window.resizable = true;
	
	t.modules.audio = false;
end;
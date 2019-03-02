--local fileMenu	= require("fileMenu");
local escapeMenu	= require("escapeMenu");
local textArea		= require("textArea");

local editor = {};

local width, height = 600, 400; --default width, height in conf.lua

local FPS = 10; -- Once set cannot be changed.


function editor.getFPS()
	return FPS;
end;



function editor.load()
	--[[ For fileMenu, but fileMenu is nor finished or may not implemented for performance purposes.
	fileMenu.load(width, 25);
	textArea.load(width, height-25);
	textArea.setPosition(0, 25);
	]]
	textArea.load(width, height);
	escapeMenu.load(300, 400);	
	
	local escapeMenuWidth, escapeMenuHeight = escapeMenu.getSize();
	escapeMenu.setPosition(width/2 - escapeMenuWidth/2, height/2 - escapeMenuHeight/2);
	
	escapeMenu.focus();
	textArea.unfocus();
	
	love.keyboard.setKeyRepeat(true);
end;

function editor.update(deltaTime)

end;

function editor.draw()
	textArea.draw();
	--fileMenu.draw();
	escapeMenu.draw();
end;

function editor.quit()
	love.window.close();
	os.exit();
end;

function editor.resize(newWidth, newHeight)
	width, height = newWidth, newHeight;
	--fileMenu.setSize(width, height);
	--textArea.setSize(width, height-25);
	--escapeMenu.setSize(width, height);
	textArea.setSize(width, height);
	
	local escapeMenuWidth, escapeMenuHeight = escapeMenu.getSize();
	escapeMenu.setPosition(width/2 - escapeMenuWidth/2, height/2 - escapeMenuHeight/2);
end;

function editor.mousepressed(x, y)
	if textArea.isFocused() then
		textArea.mousepressed(x, y);
	else
		escapeMenu.mousepressed(x, y);
	end;
	--[[
	if not fileMenu.mousepressed(x, y) then --If a mouse did press on fileMenu, no need to check for textArea.
		textArea.mousepressed(x, y);
	end;
	]]
end;


function editor.mousemoved(x, y, dx, dy)
	if escapeMenu.isFocused() then
		escapeMenu.mousemoved(x, y, dx, dy);
	end;
end;


function editor.mousereleased(x, y)
	if escapeMenu.isFocused() then
		escapeMenu.mousereleased(x, y);
	end;
end;

function editor.keypressed(key, scancode, isRepeat)
	if key == "escape" then
		if escapeMenu.isFocused() then
			escapeMenu.unfocus();
			textArea.focus();
		else
			textArea.unfocus();
			escapeMenu.focus();
		end;
		return;
	end;
	textArea.keypressed(key, scancode, isRepeat);
end;

function editor.textinput(t)
	if textArea.isFocused() then
		textArea.textinput(t);
	end;
end;

return editor;
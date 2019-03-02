local RESOURCES = require("editor_resources");
local eventManager = require("eventManager");
local sourceFiles = require("sourceFiles");

local textArea = {};

--[[
--Vertical scroll bar
local verticalScrollBarWidth	= 20; --Width for vertical scroll bar is fixed
local verticalScrollBarHeight	= 1;
local verticalScrollBarX		= 0;
local verticalScrollBarY		= 0;
]]--

--local lineNumberListWidth	= 14*3;
--local lineNumberListHeight	= 1;
--local lineNumberListX		= 0;
--local lineNumberListY		= 0;

--local width, height = 1-verticalScrollBarWidth, 1;
--local width, height = 1-lineNumberListWidth, 1;

local fileInformationPanelWidth		= 1;
local fileInformationPanelHeight	= 16; --12 + 4 because it's the size of the system font and + 4 for border.
local fileInformationPanelX			= 0;
--local fileInformationPanelY			= 0;  This is commented out, because the value is the same as the variable "height" below V


local width, height	= 1, 1 - fileInformationPanelHeight;
local x, y			= 0, 0;
local hasFocus 		= false;

local possibleVisibleLinesPerHeight = height/14; --


local currentFile = nil;
local currentLine = "";




local function newFileToEdit(sourceFile)
	currentFile = sourceFile;
	currentLine = sourceFile.currentTextLine;
end;

function textArea.setSize(newWidth, newHeight)
	--verticalScrollBarHeight = newHeight;
	--width, height = newWidth - verticalScrollBarWidth, newHeight;
	--verticalScrollBarX = x+width;
	--verticalScrollBarY = y;
	--lineNumberListHeight = newHeight;
	--width, height = newWidth - lineNumberListWidth, newHeight;
	width, height = newWidth, newHeight - fileInformationPanelHeight;
	fileInformationPanelWidth = width;
	possibleVisibleLinesPerHeight = height/14;
end;

function textArea.getSize()
	return width, height;
end;

function textArea.setPosition(newX, newY)
	x, y = newX, newY;
	--x, y = newX+lineNumberListWidth, newY;
	--verticalScrollBarX = x+width;
	--verticalScrollBarY = y;
end;

function textArea.getPosition()
	return x, y;
end;

function textArea.focus()
	hasFocus = true;
end;

function textArea.unfocus()
	hasFocus = false;
end;

function textArea.isFocused()
	return hasFocus;
end;



function textArea.load(newWidth, newHeight)
	--lineNumberListHeight = newHeight;
	
	--width = newWidth - lineNumberListWidth;
	--height = newHeight;
	
	width = newWidth;
	height = newHeight - fileInformationPanelHeight;
	
	fileInformationPanelWidth = width;
	possibleVisibleLinesPerHeight = height/14;
	
	--verticalScrollBarX = x+width;
	--verticalScrollBarY = y;
	
	eventManager.addEventListener("Edit file", newFileToEdit);
end;

function textArea.update(deltaTime)
	
end;

local FONTS		= RESOURCES.FONTS;
local setFont	= love.graphics.setFont;
local COLORS	= RESOURCES.COLORS;
local setColor	= love.graphics.setColor;
local rectangle = love.graphics.rectangle;
local print 	= love.graphics.print;
local tabConcat = table.concat;
function textArea.draw()
	if not currentFile then
		return;
	end;
	
	setFont(FONTS.CODE);
	
	setColor(COLORS.TEXTAREA_BACKGROUND);
	rectangle("fill", x, y, width, height);
	setColor(COLORS.TEXTAREA_FOREGROUND);
	local visibleEndLineIndex = currentFile.visibleStartLineIndex+possibleVisibleLinesPerHeight;
	if visibleEndLineIndex > currentFile.totalLines then
		visibleEndLineIndex = currentFile.totalLines;
	end;
	io.write(tostring(visibleEndLineIndex) .. "\n");
	for line = currentFile.visibleStartLineIndex, visibleEndLineIndex do
		print(currentFile.textLines[line], x, (line-1)*14); --14 because font size is 14
	end;
	print(currentFile.currentTextLine, x, (currentFile.currentLineIndex-1)*14);
	
	setFont(FONTS.SYSTEM);
	setColor(COLORS.TEXTAREA_PANEL_FILEINFORMATION_BACKGROUND);
	rectangle("fill", x, height, fileInformationPanelWidth, fileInformationPanelHeight);
	setColor(COLORS.TEXTAREA_PANEL_FILEINFORMATION_FOREGROUND);
	print(
		tabConcat({
			'[', currentFile.cursorColumnPosition, ', ', currentFile.currentLineIndex, '/', currentFile.totalLines, ']\t\tname: ', currentFile.fileName, '\t\tpath: ', currentFile.filePath
			}), 
		x + 1, height
		);

	
	--setColor(COLORS.TEXTAREA_VERTICAL_SCROLLBAR_BACKGROUND);
	--rectangle("fill", verticalScrollBarX, verticalScrollBarY, verticalScrollBarWidth, verticalScrollBarHeight); 
	--setColor(COLORS.TEXTAREA_LIST_LINENUMBER_BACKGROUND);
	--rectangle("fill", lineNumberListX, lineNumberListY, lineNumberListWidth, lineNumberListHeight); 
end;

function textArea.mousepressed(mouseX, mouseY)
	
end;

function textArea.keypressed(key, scancode, isRepeat)
	if not currentFile then --If there's no file opened, quit.
		return;
	end;
	if key == "return" then
		sourceFiles.addNewLine(currentFile);
	elseif key == "backspace" then
		sourceFiles.erase(currentFile);
	elseif key == "tab" then
		--source
	end;
end;

function textArea.textinput(t)
	if currentFile then
		sourceFiles.appendText(currentFile, t);
	end;
end;

return textArea;
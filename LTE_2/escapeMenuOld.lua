--There are 2 editors UI
--[[ UI 1 
local RESOURCES = require("editor_resources");
local eventManager = require("eventManager");

local function newButton(text, x, y, width, height)
	return {
		text = text;
		x = x;
		y = y;
		width = width;
		height = height;
		x2 = x+width;
		y2 = y+height;
	};
end;

local function setButtonPosition(button, x, y)
	button.x = x;
	button.y = y;
	button.x2 = x + button.width;
	button.y1 = y + button.height;
end;

local function setButtonSize(button, width, height)
	button.width = width;
	button.height = height;
end;

local function intersectsButton(button, x, y)
	local buttonX1, buttonY1 = button.x, button.y;
	local buttonX2, buttonY2 = button.x2, button.y2;
	if x >= buttonX1 and x <= buttonX2
	and y >= buttonY1 and y <= buttonY2 then
		return true;
	end;
	
	return false;
end;


local escapeMenu = {};


local width, height 	= 1, 1;
local x, y				= 0, 0;
local hasFocus 			= false;
local newFileButton, openFileButton, saveFileButton;
local numberOfButtons = 3;
local buttonBorder = 5;

function escapeMenu.setSize(newWidth, newHeight)
	width, height = newWidth, newHeight;
end;

function escapeMenu.getSize()
	return width, height;
end;

function escapeMenu.setPosition(newX, newY)
	x, y = newX, newY;
	
	local buttonWidth = math.floor(width/numberOfButtons)-2;
	local offsetY = height-20;
	
	setButtonPosition(newFileButton,	x, 							y+offsetY);
	setButtonPosition(openFileButton,	x+width/2-buttonWidth/2, 	y+offsetY);
	setButtonPosition(saveFileButton,	x+width-buttonWidth,		y+offsetY);
end;

function escapeMenu.getPosition()
	return x, y;
end;

function escapeMenu.focus()
	hasFocus = true;
end;

function escapeMenu.unfocus()
	hasFocus = false;
end;
	
function escapeMenu.isFocused()
	return hasFocus;
end;

function escapeMenu.load(newWidth, newHeight)
	width, height = newWidth, newHeight;
	
	local buttonWidth = math.floor(width/numberOfButtons)-2;
	local offsetY = height-20;
	
	newFileButton	= newButton("New file",  x, 					offsetY, buttonWidth, 20);
	openFileButton	= newButton("Open file", x+width/2-buttonWidth/2, offsetY, buttonWidth, 20);
	saveFileButton	= newButton("Save file", x+width-buttonWidth, 	offsetY, buttonWidth, 20);
end;

function escapeMenu.update(deltaTime)

end;

local COLORS	= RESOURCES.COLORS;
local setColor	= love.graphics.setColor;
local rectangle = love.graphics.rectangle;
local print		= love.graphics.print;
function escapeMenu.draw()
	if not hasFocus then return end;
	setColor(COLORS.ESCAPEMENU_BACKGROUND);
	rectangle("fill", x-buttonBorder, y-buttonBorder, width+buttonBorder*2, height+buttonBorder*2);
	setColor(COLORS.ESCAPEMENU_BUTTON_BACKGROUND);
	rectangle("fill", newFileButton.x, newFileButton.y, newFileButton.width, newFileButton.height);
	rectangle("fill", openFileButton.x, openFileButton.y, openFileButton.width, openFileButton.height);
	rectangle("fill", saveFileButton.x, saveFileButton.y, saveFileButton.width, saveFileButton.height);
	setColor(COLORS.ESCAPEMENU_BUTTON_FOREGROUND);
	print(newFileButton.text, newFileButton.x+newFileButton.width/4, newFileButton.y+newFileButton.height/4 - 2);
	print(openFileButton.text, openFileButton.x+openFileButton.width/4, openFileButton.y+openFileButton.height/4 - 2);
	print(saveFileButton.text, saveFileButton.x+saveFileButton.width/4, saveFileButton.y+saveFileButton.height/4 - 2);
end;

function escapeMenu.mousepressed(mouseX, mouseY)
	
	if intersectsButton(newFileButton, mouseX, mouseY) then
		eventManager.triggerEvent("New file");
	elseif intersectsButton(openFileButton, mouseX, mouseY) then
		eventManager.triggerEvent("Open file");
	elseif intersectsButton(saveFileButton, mouseX, mouseY) then
		eventManager.triggerEvent("Save file");
	end;
end;


--[[ SubMenus could cause lag
function escapeMenu.mousepressed(mouseX, mouseY)
	if not menusOpened then
		if mouseX >= 0 and mouseX <= width 
		and mouseY >= 0 and mouseY <= height then
			menusOpened = true;
			
			
			return true;
		end;
	end;
	
	return false;
end;
]]



return escapeMenu;
]]---

--UI 2

local RESOURCES = require("editor_resources");

local function newButton(text, x, y, width, height)
	return {
		text = text;
		x = x;
		y = y;
		width = width;
		height = height;
		x2 = x+width;
		y2 = y+height;
	};
end;

local function setButtonPosition(button, x, y)
	button.x = x;
	button.y = y;
	button.x2 = x + button.width;
	button.y1 = y + button.height;
end;

local function setButtonSize(button, width, height)
	button.width = width;
	button.height = height;
end;

local function intersectsButton(button, x, y)
	local buttonX1, buttonY1 = button.x, button.y;
	local buttonX2, buttonY2 = button.x2, button.y2;
	if x >= buttonX1 and x <= buttonX2
	and y >= buttonY1 and y <= buttonY2 then
		return true;
	end;
	
	return false;
end;


local escapeMenu = {};


local width, height 	= 1, 1;
local x, y				= 0, 0;
local hasFocus 			= false;
local newFileButton, openFileButton, saveFileButton;
local numberOfButtons = 3;
local buttonBorder = 20;

function escapeMenu.setSize(newWidth, newHeight)
	--width, height = newWidth, newHeight;
	x = newWidth/2-width/2;
	y = newHeight/2-height/2;
	local offsetY = math.floor(height/numberOfButtons)-buttonBorder/4;
	
	setButtonSize(newFileButton, width, offsetY);
	setButtonSize(openFileButton, width, offsetY);
	setButtonSize(saveFileButton, width, offsetY);
	
	setButtonPosition(newFileButton, x, y);
	setButtonPosition(openFileButton, x, y+height/2-offsetY/2);
	setButtonPosition(saveFileButton, x, y+height-offsetY);
end;

function escapeMenu.getSize()
	return width, height;
end;

function escapeMenu.setPosition(newX, newY)
	x, y = newX, newY;
	local offsetY = math.floor(height/numberOfButtons)-buttonBorder/4;
	setButtonPosition(newFileButton, x, y);
	setButtonPosition(openFileButton, x, y+height/2-offsetY/2);
	setButtonPosition(saveFileButton, x, y+height-offsetY);
end;

function escapeMenu.getPosition()
	return x, y;
end;

function escapeMenu.focus()
	hasFocus = true;
end;

function escapeMenu.unfocus()
	hasFocus = false;
end;

function escapeMenu.isFocused()
	return hasFocus;
end;

function escapeMenu.load(newWidth, newHeight)
	width, height = newWidth, newHeight;
	
	local offsetY = math.floor(height/numberOfButtons)-buttonBorder/4;
	
	newFileButton	= newButton("New file",  x, y+offsetY*0, width, offsetY);
	openFileButton	= newButton("Open file", x, y+offsetY*1, width, offsetY);
	saveFileButton	= newButton("Save file", x, y+offsetY*2, width, offsetY);
end;

function escapeMenu.update(deltaTime)

end;

local COLORS	= RESOURCES.COLORS;
local setColor	= love.graphics.setColor;
local rectangle = love.graphics.rectangle;
local print		= love.graphics.print;
function escapeMenu.draw()
	if not hasFocus then return end;
	setColor(COLORS.ESCAPEMENU_BACKGROUND);
	rectangle("fill", x-buttonBorder, y-buttonBorder, width+buttonBorder*2, height+buttonBorder*2);
	setColor(COLORS.ESCAPEMENU_BUTTON_BACKGROUND);
	rectangle("fill", newFileButton.x, newFileButton.y, newFileButton.width, newFileButton.height);
	rectangle("fill", openFileButton.x, openFileButton.y, openFileButton.width, openFileButton.height);
	rectangle("fill", saveFileButton.x, saveFileButton.y, saveFileButton.width, saveFileButton.height);
	setColor(COLORS.ESCAPEMENU_BUTTON_FOREGROUND);
	print(newFileButton.text, newFileButton.x, newFileButton.y, 0, newFileButton.width/(100), newFileButton.height/12);
end;

function escapeMenu.mousepressed(mouseX, mouseY)
	
end;


--[[ SubMenus could cause lag
function escapeMenu.mousepressed(mouseX, mouseY)
	if not menusOpened then
		if mouseX >= 0 and mouseX <= width 
		and mouseY >= 0 and mouseY <= height then
			menusOpened = true;
			
			
			return true;
		end;
	end;
	
	return false;
end;
]]



return escapeMenu;

--[=[

Failed scrollbar

local RESOURCES = require("editor_resources");
local eventManager = require("eventManager");
local newSourceFile = require("newSourceFile");

local function newButton(text, x, y, width, height)
	return {
		text = text;
		x = x;
		y = y;
		width = width;
		height = height;
		x2 = x+width;
		y2 = y+height;
	};
end;

local function setButtonPosition(button, x, y)
	button.x = x;
	button.y = y;
	button.x2 = x + button.width;
	button.y1 = y + button.height;
end;

local function setButtonSize(button, width, height)
	button.width = width;
	button.height = height;
end;

local function intersectsButton(button, x, y)
	local buttonX1, buttonY1 = button.x, button.y;
	local buttonX2, buttonY2 = button.x2, button.y2;
	if x >= buttonX1 and x <= buttonX2
	and y >= buttonY1 and y <= buttonY2 then
		return true;
	end;
	
	return false;
end;

local fileList = {
	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
	111, 112, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
	221, 222, 457, 745, 2344, 42146, 27, 28, 239, -210, 211, 212,
	331, 332, 333, 334, 335, 336, 337, 338, 339, 3310, 3311, 3312,
	5331, 5332, 5333, 5334, 5335, 5336, 5337, 5338, 5339, 53310, 53311, 53312
};
local fileListWidth, fileListHeight = 0, 0;
local fileListX, fileListY			= 0, 0;
local visibleFileListItems			= {};
local maximumNumberOfVisibleItems	= 12;
local fileListItemSelected	= false;
local fileListItemOffsetY	= 0;
local fileListVerticalScrollBarWidth		= 20; --Height and Y will be the same as fileList's
local fileListVerticalScrollBarOffsetX		= 0;
local fileListVerticalScrollBarButtonOffsetX	= 3;
local fileListVerticalScrollBarButtonOffsetY	= 0;
local fileListVerticalScrollBarButtonWidth		= 14; 
local fileListVerticalScrollBarButtonHeight		= 0; --The scrollbar's button inside will vary based on the amount of items.
local fileListVerticalScrollBarIndex			= 1;
local fileListVerticalScrollBarClicked			= false;

local function refreshFileList() --to remove files that don't exist or aren't open anymore
	local refreshedFileList = {};
	for _, file in pairs(fileList) do
		if file and file.isOpen then
			refreshedFileList[#refreshedFileList+1] = file;
		else
			file = nil;
		end;
	end;
end;

local function updateVisibleFileListItems()
	visibleFileListItems = {};
	if #fileList > maximumNumberOfVisibleItems then
		local offset = fileListHeight / #fileList;
		fileListVerticalScrollBarButtonHeight = fileListHeight - offset;
		fileListVerticalScrollBarButtonOffsetY = (fileListVerticalScrollBarIndex - 1)/(#fileList - maximumNumberOfVisibleItems) * offset;
		for i = fileListVerticalScrollBarIndex, fileListVerticalScrollBarIndex+maximumNumberOfVisibleItems-1 do
			visibleFileListItems[i - fileListVerticalScrollBarIndex + 1] = fileList[i];
		end;
	else
		fileListVerticalScrollBarButtonHeight = 0;
		fileListVerticalScrollBarButtonOffsetY = 0;
		for i = 1, maximumNumberOfVisibleItems do
			visibleFileListItems[i] = fileList[i];
		end;
	end;
end;

local function addFileToFileList(sourceFile)
	fileList[#fileList+1] = sourceFile;
	updateVisibleFileListItems();
end;

local function removeFileToFileList(sourceFile)
	for _, file in pairs(fileList) do
		if file == sourceFile then
			sourceFile.isOpen = false;
		end;
	end;
	refreshFileList();
	updateVisibleFileListItems();
end;


local escapeMenu = {};
local width, height 	= 1, 1;
local x, y				= 0, 0;
local hasFocus 			= false;

local newFileButton, openFileButton, saveFileButton;
local numberOfButtons = 2;
local buttonBorder = 5;

function escapeMenu.setSize(newWidth, newHeight)
	width, height = newWidth, newHeight;
end;

function escapeMenu.getSize()
	return width, height;
end;

function escapeMenu.setPosition(newX, newY)
	x, y = newX, newY;
	
	fileListX, fileListY = x, y;
	fileListVerticalScrollBarOffsetX = x + fileListWidth;
	
	local buttonWidth = math.floor(width/numberOfButtons)-2;
	local offsetY = height-20;

	setButtonPosition(newFileButton,	x, 							y+offsetY);
	setButtonPosition(saveFileButton,	x+width-buttonWidth,		y+offsetY);
end;

function escapeMenu.getPosition()
	return x, y;
end;

function escapeMenu.focus()
	hasFocus = true;
end;

function escapeMenu.unfocus()
	hasFocus = false;
end;
	
function escapeMenu.isFocused()
	return hasFocus;
end;

function escapeMenu.load(newWidth, newHeight)
	width, height = newWidth, newHeight;
	
	fileListWidth, fileListHeight = width-fileListVerticalScrollBarWidth, height - 25;
	fileListItemOffsetY = fileListHeight / maximumNumberOfVisibleItems;
	fileListVerticalScrollBarHeight = fileListHeight;
	updateVisibleFileListItems();
	
	local buttonWidth = math.floor(width/numberOfButtons)-2;
	local offsetY = height-20;
	
	newFileButton	= newButton("New file",  x, 					offsetY, buttonWidth, 20);
	saveFileButton	= newButton("Save file", x+width-buttonWidth, 	offsetY, buttonWidth, 20);
end;

function escapeMenu.update(deltaTime)

end;

local COLORS	= RESOURCES.COLORS;
local setColor	= love.graphics.setColor;
local rectangle = love.graphics.rectangle;
local print		= love.graphics.print;
function escapeMenu.draw()
	if not hasFocus then return end;
	
	setColor(COLORS.ESCAPEMENU_BACKGROUND);
	rectangle("fill", x-buttonBorder, y-buttonBorder, width+buttonBorder*2, height+buttonBorder*2);
	
	
	
	setColor(COLORS.ESCAPEMENU_LIST_BACKGROUND);
	rectangle("fill", fileListX, fileListY, fileListWidth, fileListHeight);
	setColor(COLORS.ESCAPEMENU_LIST_FOREGROUND);
	for i = 1, maximumNumberOfVisibleItems do
		rectangle("line", fileListX, fileListY + fileListItemOffsetY * (i-1), fileListWidth, fileListItemOffsetY);
		print(fileList[visibleFileListItems[i]], fileListX, fileListY + fileListItemOffsetY * (i-1));
	end;
	
	setColor(COLORS.ESCAPEMENU_LIST_SCROLLBAR_BACKGROUND);
	rectangle("fill", fileListVerticalScrollBarOffsetX, fileListY, fileListVerticalScrollBarWidth, fileListHeight);
	setColor(COLORS.ESCAPEMENU_LIST_SCROLLBAR_FOREGROUND);
	rectangle("fill", fileListVerticalScrollBarOffsetX + fileListVerticalScrollBarButtonOffsetX, fileListY + fileListVerticalScrollBarButtonOffsetY,
		fileListVerticalScrollBarButtonWidth, fileListVerticalScrollBarButtonHeight); 
	
	
	
	setColor(COLORS.ESCAPEMENU_BUTTON_BACKGROUND);
	rectangle("fill", newFileButton.x, newFileButton.y, newFileButton.width, newFileButton.height);
	rectangle("fill", saveFileButton.x, saveFileButton.y, saveFileButton.width, saveFileButton.height);
	setColor(COLORS.ESCAPEMENU_BUTTON_FOREGROUND);
	print(newFileButton.text, newFileButton.x+newFileButton.width/4+12, newFileButton.y+newFileButton.height/4 - 2);
	print(saveFileButton.text, saveFileButton.x+saveFileButton.width/4+12, saveFileButton.y+saveFileButton.height/4 - 2);
end;

function escapeMenu.mousepressed(mouseX, mouseY)
	if fileListItemSelected and intersectsButton(saveFileButton, mouseX, mouseY) then
		eventManager.triggerEvent("Save file");
	elseif intersectsButton(newFileButton, mouseX, mouseY) then
		eventManager.triggerEvent("New file");
	elseif #fileList > maximumNumberOfVisibleItems
	and mouseX >= fileListVerticalScrollBarOffsetX and mouseX <= fileListVerticalScrollBarOffsetX + fileListVerticalScrollBarButtonWidth 
	and	mouseY >= fileListY and mouseY <= fileListY + fileListHeight then
		fileListVerticalScrollBarClicked = true;
	end;
end;

function escapeMenu.mousemoved(x, y, dx, dy)  
	if fileListVerticalScrollBarClicked then
		fileListVerticalScrollBarIndex = math.floor((y - fileListY) * (#fileList - maximumNumberOfVisibleItems)/fileListHeight) * maximumNumberOfVisibleItems;
		io.write(tostring(fileListVerticalScrollBarIndex).."\n");
		--fileListVerticalScrollBarIndex = fileListVerticalScrollBarIndex + math.ceil(dy);
		if fileListVerticalScrollBarIndex < 1 then
			fileListVerticalScrollBarIndex = 1;
		elseif fileListVerticalScrollBarIndex > #fileList - maximumNumberOfVisibleItems then
			fileListVerticalScrollBarIndex = #fileList - maximumNumberOfVisibleItems + 1;
		end;
		updateVisibleFileListItems();
	end;
end;


function escapeMenu.mousereleased(mouseX, mouseY)
	--if fileListItemSelected and intersectsButton(saveFileButton, mouseX, mouseY) then
		--eventManager.triggerEvent("Save file");
	--elseif intersectsButton(newFileButton, mouseX, mouseY) then
		--eventManager.triggerEvent("New file");
	--elseif #fileList > maximumNumberOfVisibleItems 
	--and mouseX >= fileListVerticalScrollBarOffsetX and mouseX <= fileListVerticalScrollBarOffsetX + fileListVerticalScrollBarButtonWidth 
	--and	mouseY >= fileListY and mouseY <= fileListY + fileListHeight then
		--fileListVerticalScrollBarClicked = true;
		fileListVerticalScrollBarClicked = false;
	--end;
end;


--[[ SubMenus could cause lag
function escapeMenu.mousepressed(mouseX, mouseY)
	if not menusOpened then
		if mouseX >= 0 and mouseX <= width 
		and mouseY >= 0 and mouseY <= height then
			menusOpened = true;
			
			
			return true;
		end;
	end;
	
	return false;
end;
]]



return escapeMenu;

]=]
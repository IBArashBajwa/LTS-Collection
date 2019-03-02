local RESOURCES = require("editor_resources");
local eventManager = require("eventManager");
local sourceFiles = require("sourceFiles");

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
	button.y2 = y + button.height;
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

local fileList = {};
local fileListWidth, fileListHeight = 0, 0;
local fileListX, fileListY			= 0, 0;
local maximumNumberOfVisibleItems	= 12;
local fileListItemSelected	= nil;
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
		if file then
			refreshedFileList[#refreshedFileList+1] = file;
		else
			file = nil;
		end;
	end;
end;

local function updateVisibleFileListItems() --Update based on scrollBarIndex
	if #fileList > maximumNumberOfVisibleItems then 
		local offset = fileListHeight / (#fileList/maximumNumberOfVisibleItems);
		fileListVerticalScrollBarButtonHeight = fileListHeight - offset;
		fileListVerticalScrollBarButtonOffsetY = (fileListVerticalScrollBarIndex - 1)/(#fileList - maximumNumberOfVisibleItems) * offset;
	else
		fileListVerticalScrollBarButtonHeight = 0;
		fileListVerticalScrollBarButtonOffsetY = 0;
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
	
	eventManager.addEventListener("New file", addFileToFileList);
end;

function escapeMenu.update(deltaTime)

end;

local FONTS		= RESOURCES.FONTS;
local setFont	= love.graphics.setFont;
local COLORS	= RESOURCES.COLORS;
local setColor	= love.graphics.setColor;
local rectangle = love.graphics.rectangle;
local print		= love.graphics.print;
function escapeMenu.draw()
	if not hasFocus then return end;
	
	setFont(FONTS.SYSTEM);
	
	setColor(COLORS.ESCAPEMENU_BACKGROUND);
	rectangle("fill", x-buttonBorder, y-buttonBorder, width+buttonBorder*2, height+buttonBorder*2);
	
	
	
	setColor(COLORS.ESCAPEMENU_LIST_BACKGROUND);
	rectangle("fill", fileListX, fileListY, fileListWidth, fileListHeight);
	setColor(COLORS.ESCAPEMENU_LIST_FOREGROUND);
	local fileListItemY = 0;
	for i = fileListVerticalScrollBarIndex, fileListVerticalScrollBarIndex+maximumNumberOfVisibleItems-1 do
		local sourceFile = fileList[i];
		if sourceFile then
			if sourceFile == fileListItemSelected then
				setColor(COLORS.ESCAPEMENU_LIST_SELECTION_FOREGROUND);
				rectangle("line", fileListX, fileListY + fileListItemOffsetY * fileListItemY, fileListWidth, fileListItemOffsetY);
				print(sourceFile.fileName, fileListX, fileListY + fileListItemOffsetY * fileListItemY);
				setColor(COLORS.ESCAPEMENU_LIST_FOREGROUND);
			else
				rectangle("line", fileListX, fileListY + fileListItemOffsetY * fileListItemY, fileListWidth, fileListItemOffsetY);
				print(sourceFile.fileName, fileListX, fileListY + fileListItemOffsetY * fileListItemY);
			end;
			fileListItemY = fileListItemY + 1;
		end;
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

local id = 1;
function escapeMenu.mousepressed(mouseX, mouseY)
	if fileListItemSelected and intersectsButton(saveFileButton, mouseX, mouseY) then
		eventManager.triggerEvent("Save file");
	elseif intersectsButton(newFileButton, mouseX, mouseY) then
		eventManager.triggerEvent("New file", sourceFiles.newSourceFile(tostring(id)));
		id = id + 1;
	elseif mouseY >= fileListY and mouseY <= fileListY + fileListHeight then --I
		if #fileList > maximumNumberOfVisibleItems 
		and mouseX >= fileListVerticalScrollBarOffsetX and mouseX <= fileListVerticalScrollBarOffsetX + fileListVerticalScrollBarButtonWidth  then
			
			fileListVerticalScrollBarClicked = true;
		
		elseif mouseX >= fileListX and mouseX <= fileListX + fileListWidth then
			local itemIndex = math.ceil((mouseY - fileListY) * ((#fileList-maximumNumberOfVisibleItems)/fileListHeight));
			if itemIndex < 1 then	
				itemIndex = 1;
			elseif itemIndex > #fileList - maximumNumberOfVisibleItems then
				itemIndex= #fileList - maximumNumberOfVisibleItems + 1;
			end;
			local itemClickedOnFileList = fileList[itemIndex];
			if fileListItemSelected and fileListItemSelected == itemClickedOnFileList then --Clicking on an already selected item, in other words double click
				eventManager.triggerEvent("Edit file", fileListItemSelected);
			else
				fileListItemSelected = itemClickedOnFileList;
				eventManager.triggerEvent("File selected", fileListItemSelected);
			end;
		end;
	end;
end;

function escapeMenu.mousemoved(mouseX, mouseY, mouseDX, mouseDY)  
	if fileListVerticalScrollBarClicked then
		fileListVerticalScrollBarIndex = math.ceil((mouseY - fileListY) * ((#fileList-maximumNumberOfVisibleItems)/fileListHeight)); --* maximumNumberOfVisibleItems;
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
	fileListVerticalScrollBarClicked = false;
end;

return escapeMenu;
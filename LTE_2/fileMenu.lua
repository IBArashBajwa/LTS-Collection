local RESOURCES = require("editor_resources");

local fileMenu = {};


local width, height 	= 1, 1;
local x, y				= 0, 0;
local hasFocus 			= false;
local menusOpened 		= false;
local menus				= {};

function fileMenu.setSize(newWidth, newHeight)
	width, height = newWidth, newHeight;
end;

function fileMenu.getSize()
	return width, height;
end;

function fileMenu.setPosition(newX, newY)
	x, y = newX, newY;
end;

function fileMenu.getPosition()
	return x, y;
end;

function fileMenu.addMenu(menuName)
	if type(menuName) ~= "string" then
		error("First argument of addSubMenu must be a string!", 2);
	end;
	if subMenus[menuName] then
		error(tostring(menuName).." already exists!", 2);
	end;
	subMenus[menuName] = {
		label = menuName;
	};
end;

function fileMenu.addItemToMenu(menuName)
	if subMenus[menuName] == nil then
		error("Can't add item to "..tostring(menuName));
	end;
	
end;



function fileMenu.load(newWidth, newHeight)
	width, height = newWidth, newHeight;
end;

function fileMenu.update(deltaTime)

end;

local COLORS	= RESOURCES.COLORS;
local setColor	= love.graphics.setColor;
local rectangle = love.graphics.rectangle;
function fileMenu.draw()
	setColor(COLORS.FILEMENU_BACKGROUND);
	rectangle("fill", x, y, width, height);
end;

--[[ SubMenus could cause lag
function fileMenu.mousepressed(mouseX, mouseY)
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



return fileMenu;
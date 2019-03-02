--Problems I noticed that I made were that
--The codingArea, he commandBar were firing important vents, this is not how it should've been.
--We need to make it so that we can listen to the events, and then choose what we want to do.

editor = {}
utf8 = require("utf8")
commandHandler = require("commandHandler")

local codingArea = require("editor.codingArea")
local commandBar = require("editor.commandBar")

local focusedComponent

local width, height, codingAreaHeight

local files = {}
local currentFile = nil

function editor.load()
	-- width, height = love.graphics.getWidth(), love.graphics.getHeight(),
	editor.onWindowSizeChanged(love.graphics.getWidth(), love.graphics.getHeight()) --calibrate editor with width and height
	codingArea.load() 
	commandBar.load()
	focusedComponent = codingArea -- this is one that should receive the text input for coding
end


function editor.newFile(fileName, filePath, lines)
	local id = #files+1
	local file = {
		["id"] = id,
		["name"] = fileName,
		["path"] = filePath,
		["isSaved"] = false,    
        ["lines"] = {},        
	}
	files[id] = file
	currentFile = file
end

function editor.closeFile()
    if currentFile then 
        table.remove(files, currentFile.id)
	    currentFile = nil
    end
	codingArea.setText("")
end

function editor.getOpenedFile()
	return currentFile
end

function editor.setFocusedComponent(component)
	focusedComponent = component
end

function editor.getFocusedComponent()
	return focusedComponent
end

function editor.getCodingArea()
	return codingArea
end

function editor.getCommandBar()
	return commandBar
end

function editor.onWindowSizeChanged(newWidth, newHeight)
    width, height = newWidth, newHeight
    codingAreaHeight = height - 14
end

function editor.onKeyPressed(key, scancode, isRepeat)
	if key == "escape" then
        if focusedComponent == commandBar then
            focusedComponent = codingArea
        else
            focusedComponent = commandBar
        end
	end
	if focusedComponent == nil then return end
	if key == "backspace" then --https://love2d.org/wiki/love.textinput thank you
		focusedComponent.erase()
	elseif key == "return" then
        focusedComponent.addNewLine()
    elseif key == "tab" then
        focusedComponent.addText("\t")
    end
end

function editor.onKeyReleased()

end

function editor.onTextTyped(text)
	if focusedComponent == codingArea then
		codingArea.addText(text)
	elseif focusedComponent == commandBar then
		commandBar.addText(text)
    end
end     

function editor.update(deltaTime)
    commandHandler.update(deltaTime)
end

function editor.draw()
    codingArea.draw(0, 0, width, codingAreaHeight)
    commandBar.draw(0, codingAreaHeight, width, 14)
end


return editor


--[[
previous code
variables:
local tabNameFont
local lineFont
local codeText, codeTextFont

load function:

    tabNameFont = love.graphics.newFont(18)
    lineFont = love.graphics.newFont(16)

    codeTextFont = love.graphics.newFont(16)
    codeText = love.graphics.newText(codeTextFont, "")
    codeText:set({
        {1, 1, 0}, "function", 
        {1, 1, 1}, " syntaxExample(a)\n\tprint(a)\n",   
        {1, 1, 0}, "end",
    })



draw function:
 --left arrow
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", 0, 0, 20, 20)
    
        --right arrow
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 20, 0, 20, 20)
    
        --top tab line
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 20, 0, love.graphics.getWidth() - 40, 20)
        
        --a file tab
        love.graphics.setColor(0.5, 0.5, 1)
        love.graphics.rectangle("fill", 20, 0, 100, 20)
        
        --file tab name
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(tabNameFont)
        love.graphics.print("File name", 20, 0)
    
        --a file tab close button
        love.graphics.setColor(0.8, 0.5, 0.8)
        love.graphics.rectangle("fill", 110, 0, 10, 20)
    
        --left side line numbers
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 20, 20, love.graphics.getHeight() - 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(lineFont)
        for i = 1, 6 do
            love.graphics.print(tostring(i), 4, 2+i*18)
        end
    
        --rectangle that to show that line side ended
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 20, 20, 20)
    
        --bottom file info 
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 20, love.graphics.getHeight() - 20, love.graphics.getWidth()-20, 20)
    
        --code textbox area
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(codeText, 20, 20)    
]]
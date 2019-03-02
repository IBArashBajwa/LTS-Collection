local utf8 = utf8
local commandBar = {}

local commandText, commandTextFont

function commandBar.load()
    commandTextFont = love.graphics.newFont(11)
    commandText = ""
end


function commandBar.addText(text)
    commandText = commandText .. text 
end

function commandBar.setText(text)
    commandText = text
end

function commandBar.erase()
    local byteoffset = utf8.offset(commandText, -1)
    if byteoffset then
        commandText = string.sub(commandText, 1, byteoffset - 1)
    end
end

function commandBar.addNewLine()
    if commandText == "" then return end--if command is empty, set commandText to "" and return
    local command = commandText --doing this, because the command that is executed may want to change the command bar text
    --commandText = "" --this resets the command bar text, so we have to be careful, reset before executing the command, and
    commandHandler.execute(command) --to keep the command, we use a temp variable
    --[[
    local commandWord = ""
    local wordsFound = {}
    local i = 0
    for word in commandText:gmatch("%S+") do
        if i == 0 then --the first word will be the command, the rest will be inputs, so let's separate them
            commandWord = word
            i = i + 1
        else
            wordsFound[i] = word
        end
    end
    commandText = ""
    if commands[commandWord] then --if the command is found
        commands[commandWord](unpack(wordsFound)) --call the command function, with the inputs
    else
        commands.unknownCommand(commandWord, unpack(wordsFound))
    end
    ]]
end

function commandBar.draw(x, y, width, height)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(0.6, 1, 0.6)
    love.graphics.setFont(commandTextFont)
    love.graphics.print(commandText, x+2, y)
end

return commandBar
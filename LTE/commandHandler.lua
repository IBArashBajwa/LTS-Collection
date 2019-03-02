commandHandler = {}
local commandStack = {}
local oldCommand = ""

local function pushCommandStack(f, args) --le problem here is that we should know what the new input was, to fix that we can use latestInput
                                                --but then we have another problem that is that we don't know what the input for the previous
    commandStack[#commandStack+1] = {f, args} --command was.. very fun.
end

local function popCommandStack(inputs)
    if #commandStack == 0 then return end --nothing to pop
    local command = commandStack[#commandStack]
    table.remove(commandStack)
    --print(unpack(command[2]))
    command[1](inputs, command[2])
end

--[[
    file saving order
    order -1: ask if user wants to try saving again
    order 0: ask name
    order 1: set name & ask path
    order 2: set path & try to create file
]]

local function saveFile(inputs, args) --args --> {file, order, inputs}
    local file, order = args[1], args[2]
    if order == -1 then
        local confirmation = inputs[#inputs]

        if confirmation == "y" then -- go to order 0
            saveFile(inputs, {file, 0})
        elseif confirmation == "n" then
            return -- nothing
        else --ask again
            editor.getCommandBar().setText("Failed to create file, try again(y/n): ")
            pushCommandStack(saveFile, {file, -1})
        end
    elseif order == 0 then
        local fileName = file["name"] or ""
        editor.getCommandBar().setText("file-name: " .. fileName)
        pushCommandStack(saveFile, {file, 1})
    elseif order == 1 then
        file["name"] = inputs[#inputs]
        local filePath = file["path"] or ""
        editor.getCommandBar().setText("file-path: " .. filePath)
        pushCommandStack(saveFile, {file, 2})
    elseif order == 2 then
        file["path"] = inputs[#inputs]
        local ioFile = io.open(file["path"] .. "/" .. file["name"], "w")
        if ioFile == nil then
            editor.getCommandBar().setText("Failed to create file, try again(y/n): ")
            pushCommandStack(saveFile, {file, -1})
            return
        end
        for _, line in pairs(file["lines"]) do
            ioFile:write(line, "\n")
        end
        ioFile:flush()
        ioFile:close()
        file["isSaved"] = true
        editor.getCommandBar().setText("")
    end
end

local function askSaveFile(inputs)
    local confirmation = inputs[#inputs]
    if confirmation == "y" then --save file
        local file = editor.getOpenedFile()
        saveFile(inputs, {file, 0})
    elseif confirmation == "n" then
        editor.closeFile()
    else
        print("Not sure if user wants to save file: "..tostring(confirmation))
        pushCommandStack(askSaveFile)
    end
end

function commandHandler.update(deltaTime)
    --if #commandStack > 0 then
        --editor.setFocusedComponent(editor.getCommandBar())
        --popCommandStack()
   -- end
end

commandHandler.unknownCommand = function(a, b, c, d)
    if oldCommand == "" then return end --random message, ignore it

    if oldCommand == "save" and a == "save" and b == "file" and c == "(y/n):" then
        if d == "y" then
            oldCommand = "save-filename"
            editor.getCommandBar().setText("filename: " .. editor.getOpenedFile().fileName)
        elseif d == "n" then
            oldCommand = ""
        end
    elseif oldCommand == "save-filename" and a == "filename:" then
        if b then
            editor.getOpenedFile().fileName = b 
        end
        editor.getCommandBar().setText("filepath: " .. editor.getOpenedFile().filePath)
        oldCommand = "save-filepath"
    elseif oldCommand == "save-filepath" and a == "filepath:" then
        editor.getCommandBar().setText("filepath: " .. editor.getOpenedFile().filePath)
        oldCommand = ""
    end
end

commandHandler["new"] = function(input)
    if oldCommand ~= "" then return end
    local currentFile = editor.getOpenedFile()
    if currentFile and not currentFile["isSaved"] then
        --editor.saveFile()
        --commandHandler["save"](currentFile["fileName"], currentFile["filePath"])
        --pushCommandStack(commandHandler["save"], input)
        editor.getCommandBar().setText("save file (y/n): ")
        pushCommandStack(askSaveFile)
        return
    end
    editor.closeFile()
    editor.newFile()
end

commandHandler["open"] = function(filePath)
    if oldCommand ~= "" and not filePath then print("nope") return end
    local file = io.open(filePath, "r")
    if not file then --if filepath doesn't exist, is it just a file name in this path
        print(love.filesystem.getSourceBaseDirectory()) -- never mind, this should be project path, not program path
        file = io.open(love.filesystem.getSourceBaseDirectory() .. "/" .. filePath, "r")
    end
    if file then
        editor.getCodingArea().setText("")
        for line in file:lines() do
            editor.getCodingArea().addNewLine(line)
        end
        file:close()
    end
end

commandHandler["save"] = function(inputs)
    --oldCommand = "save"
    editor.getCommandBar().setText("save file (y/n): ")
    pushCommandStack(askSaveFile, inputs)
end

commandHandler.execute = function(text)
    local command = nil
    local inputs = {}
    local i = 0
    for word in text:gmatch("%S+") do
        if i==0 then
            command = word
        else
            inputs[i] = word
        end
        i = i + 1
    end

    
    if #commandStack > 0 then
        popCommandStack(inputs)
        return
    end

    editor.getCommandBar().setText("")
    local commandFunction = commandHandler[command]
    if commandFunction then
        --commandHandler[command](unpack(inputs)) 
        pushCommandStack(commandFunction, inputs)
        popCommandStack()
    end

    --editor.setFocusedComponent(editor.getCommandBar())
    --popCommandStack()
end


return commandHandler


--[[ nope not love file system
 print(filePath)
    local info = love.filesystem.getInfo(filePath)
    print("yup", info)
    if info and info.type == "file" then
        print("hello file")
        editor.getCodingArea().setText("")
        for line in love.filesystem.lines(filePath) do
            editor.getCodingArea().addNewLine(line)
        end
    end
]]
local utf8 = utf8
local codingArea = {}

local linesOfCode = {
    ""
}


local currentLineOfCode
local codingFont

local currentRow, currentColumn = 1, 1
local rowOffset, columnOffset = 0, 0

function codingArea.load()
    currentLineOfCode = linesOfCode[currentRow]
    codingFont = love.graphics.newFont(16)
    rowOffset = codingFont:getHeight()
    columnOffset = codingFont:getWidth("")
    --codingText = love.graphics.newText(codingFont, code)
end

function codingArea.addText(newCode)
    currentLineOfCode = currentLineOfCode .. newCode
    linesOfCode[currentRow] = currentLineOfCode
    columnOffset = codingFont:getWidth(currentLineOfCode)
    --codingText:add(newCode)
end

function codingArea.addNewLine(newCodeLine)
    currentRow = currentRow + 1
    linesOfCode[currentRow] = ""
    currentLineOfCode = ""
    columnOffset = 0
    currentColumn = 0
    --codingText:set(code)
end

function codingArea.setText(newCode)
    codingText = newCode
    --codingText:set(code)
end

function codingArea.getCode()
    return codingText
end

function codingArea.erase()
    if currentLineOfCode == "" and currentRow > 1 then
        table.remove(linesOfCode)
        currentRow = currentRow - 1
        currentLineOfCode = linesOfCode[currentRow]
        columnOffset = codingFont:getWidth(currentLineOfCode)
        return
    end
    local byteoffset = utf8.offset(currentLineOfCode, -1)
    if byteoffset then
        currentLineOfCode = string.sub(currentLineOfCode, 1, byteoffset - 1)
        linesOfCode[currentRow] = currentLineOfCode
        columnOffset = codingFont:getWidth(currentLineOfCode)
    end
end


function codingArea.draw(x, y, width, height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", x, y, width, height) --the background
    love.graphics.setColor(1, 1, 1)
    for i, line in pairs(linesOfCode) do
        love.graphics.setFont(codingFont)
        love.graphics.print(line, x, y+rowOffset*(i-1))
    end
    love.graphics.setColor(0.8, 1, 0.8)
    love.graphics.rectangle("fill", columnOffset, (currentRow-1)*rowOffset, 1, rowOffset)
    --love.graphics.draw(codingText, x, y)
end

return codingArea

local button = {}

local buttonsCreated = {}

function button.new(text, x, y, width, height, textColor, backgroundColor, onClick)
    local newButton = {
        text = text or "button",
        --loveText = love.graphics.newText(), not necessary
        x = x or 0,
        y = y or 0,
        width = width or 10,
        height = height or 10,
        textColor = textColor or {0, 0, 0},
        backgroundColor = backgroundColor or {1, 1, 1},
        onClick = onClick or function() end
    }

    buttonsCreated[#buttonsCreated+1] = newButton

    return newButton
end

function button.setClickEvent(button, event)
    button.onClick = event
end

function button.mousepressed(x, y, mouseButton)
    if mouseButton == 1 then --left mouse click
        for k, v in pairs(buttonsCreated) do
            if x >= v.x and x <= v.x + v.width and y >= v.y and y <= v.y + v.height then
                v.onClick()
            end
        end
    end
end

function button.draw(button)
    love.graphics.setColor(button.backgroundColor)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
    love.graphics.setColor(button.textColor)
    love.graphics.print(button.text, button.x, button.y)
    --love.graphics.draw(button.loveText)
end

return button
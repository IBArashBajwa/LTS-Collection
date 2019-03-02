local uiButton = require("ui.button")

local welcomePage = {}

local welcomeText, welcomeTextFont
local optionTextFont, options


function optionClickEvent()
    print("\a")
end

function welcomePage.load()
    welcomeTextFont = love.graphics.newFont(42)
    welcomeText = "Welcome back!"--love.graphics.newText(welcomeTextFont, "Welcome back!")

    optionTextFont = love.graphics.newFont(20)
    
    options = {
        uiButton.new("Option 1", 20, 100, 200, 30, nil, nil, optionClickEvent),
        uiButton.new("Option 2", 20, 130, 200, 30, nil, nil, optionClickEvent),
        uiButton.new("Option 3", 20, 160, 200, 30, nil, nil, optionClickEvent),
        uiButton.new("Option 4", 20, 190, 200, 30, nil, nil, optionClickEvent),
    }


end


function welcomePage.mousepressed(...)
    uiButton.mousepressed(...)
end

function welcomePage.draw()
    love.graphics.setColor({1, 1, 1})
    love.graphics.setFont(welcomeTextFont)
    love.graphics.print(welcomeText, 10, 30)--love.graphics.draw(welcomeText, 10, 30)

    love.graphics.setFont(optionTextFont)
    for i, v in pairs(options) do
        uiButton.draw(v)
        --love.graphics.draw(v, 20, 100+i*30)
    end

    --uiButton.draw(buttonTest)
end

return welcomePage



--[[previous code

local uiButton = require("ui.button")

local welcomePage = {}

local welcomeText, welcomeTextFont
local optionTextFont, options


local buttonTest, buttonTestClickEvent

function welcomePage.load()
    welcomeTextFont = love.graphics.newFont(42)
    welcomeText = love.graphics.newText(welcomeTextFont, "Welcome back!")

    optionTextFont = love.graphics.newFont(20)
    options = {
        love.graphics.newText(optionTextFont, "Option 1"),
        love.graphics.newText(optionTextFont, "Option 2"),
        love.graphics.newText(optionTextFont, "Option 3"),
        love.graphics.newText(optionTextFont, "Option 4")
    }

    buttonTest = uiButton.new("Click me :-)", 0, 0, 100, 50)
    uiButton.setClickEvent(buttonTest, buttonTestClickEvent)
end

function buttonTestClickEvent()
    buttonTest.text = "Thank you for clicking me, now my life has purpose, and this is outside of the box."
end

function welcomePage.mousepressed(...)
    uiButton.mousepressed(...)
end

function welcomePage.draw()
    love.graphics.draw(welcomeText, 10, 30)

    for i, v in pairs(options) do
        love.graphics.draw(v, 20, 100+i*30)
    end

    uiButton.draw(buttonTest)
    love.graphics.setColor({1, 1, 1})
end

return welcomePage
]]
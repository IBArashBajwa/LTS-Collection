local welcomePage = require("welcome_page")
local editor = require("editor")

function love.load()
    --welcomePage.load()
    love.keyboard.setKeyRepeat(true) --to enable key repeats/keys held down, for example, backspace
    editor.load()
end

function love.update(deltaTime)
    editor.update(deltaTime)
end

function love.draw()
    --welcomePage.draw()
    editor.draw()
end


function love.resize(width, height)
    editor.onWindowSizeChanged(width, height)
end

function love.textinput(...)
    editor.onTextTyped(...)
end

function love.keypressed(...)
    editor.onKeyPressed(...)
end

function love.keyreleased(...)
    editor.onKeyReleased(...)
end

function love.mousepressed(...)
    --welcomePage.mousepressed(...)
end

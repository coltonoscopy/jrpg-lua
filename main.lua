-- Callbacks for key pressed, in case we spread over multiple files
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

require 'ui/Panel'
require 'ui/ProgressBar'
require 'ui/Scrollbar'
require 'ui/Selection'
require 'ui/Textbox'
push = require 'push'

require 'StateStack'

virtualWidth = 384
virtualHeight = 216

love.graphics.setFont(love.graphics.newFont('fonts/04B_03__.TTF', 8))

stack = StateStack:Create()

stack:AddFitted(0, 0,      'Hello!')
stack:AddFitted(-25, 25,   'World!')
stack:AddFitted(-50, 50,   'Lots')
stack:AddFitted(-75, 75,   'of')
stack:AddFitted(-100, 100, 'boxes!')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = false,
        resizable = true
    })
end

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.update(dt)
    stack:Update(dt)
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.draw()
    push:apply('start')
    stack:Render()
    push:apply('end')
end

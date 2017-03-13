require 'ui/Panel'
push = require 'push'

virtualWidth = 384
virtualHeight = 216

local gPanel = Panel:Create {
    texture = 'graphics/simple_panel.png',
    size = 3
}
local left = virtualWidth / 2 - 100
local top = virtualHeight / 2
local right = virtualWidth / 2 + 100
local bottom = virtualHeight / 2 + 100

gPanel:Position(left, top, right, bottom)

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = true,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'up' then
        top = top - 1
        bottom = bottom - 1
        gPanel:Position(left, top, right, bottom)
    end
    if key == 'down' then
        top = top + 1
        bottom = bottom + 1
        gPanel:Position(left, top, right, bottom)
    end
    if key == 'left' then
        left = left - 1
        right = right - 1
        gPanel:Position(left, top, right, bottom)
    end
    if key == 'right' then
        left = left + 1
        right = right + 1
        gPanel:Position(left, top, right, bottom)
    end
end

function love.draw()
    push:apply('start')
    gPanel:Render()
    push:apply('end')
end

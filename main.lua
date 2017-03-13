require 'ui/Panel'
push = require 'push'

virtualWidth = 384
virtualHeight = 216

local gPanel = Panel:Create {
    texture = 'graphics/gradient_panel.png',
    size = 3
}

gPanel:CenterPosition(0, 0, 128, 32)

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
end

function love.draw()
    push:apply('start')
    gPanel:Render()
    love.graphics.printf('Hello World', virtualWidth / 2 - 128, virtualHeight / 2 - 8,
        virtualWidth / 2 + 64, 'center')
    push:apply('end')
end

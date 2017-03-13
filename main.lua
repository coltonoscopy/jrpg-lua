require 'ui/Panel'
require 'ui/Textbox'
push = require 'push'

virtualWidth = 384
virtualHeight = 216

local textbox = Textbox:Create {
    text = 'hello',
    textScale = 2,
    size = {
        left = -100,
        right = 100,
        top = 32,
        bottom = -32,
    },
    textbounds = {
        left = 10,
        right = -10,
        top = -10,
        bottom = 10
    },
    panelArgs = {
        texture = 'graphics/gradient_panel.png',
        size = 3
    }
}

gStart = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = true,
        resizable = true
    })
end

function love.update(dt)
    if gStart then
        if not textbox:IsDead() then
            textbox:Update(dt)
        end
    end
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        gStart = true
        textbox:OnClick()
    end
end

function love.draw()
    push:apply('start')
    if not gStart then
        love.graphics.printf('Press space.', 0, virtualHeight / 2,
            virtualWidth, 'center')
        push:apply('end')
        return
    end
    if not textbox:IsDead() then
        textbox:Render()
    end
    push:apply('end')
end

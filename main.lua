require 'ui/Panel'
require 'ui/Textbox'
push = require 'push'

virtualWidth = 384
virtualHeight = 216

function CreateFixed(x, y, width, height, text)
    local padding = 10
    local textScale = 1.5
    local panelTileSize = 3
    local wrap = width - padding * 2

    return Textbox:Create {
        wrap = wrap,
        text = text,
        textScale = textScale,
        size = {
            left = x - width / 2,
            right = x + width / 2,
            top = y - height / 2,
            bottom = y + height / 2,
        },
        textbounds = {
            left = padding,
            right = -padding,
            top = -padding,
            bottom = padding
        },
        panelArgs = {
            texture = 'graphics/gradient_panel.png',
            size = 3
        }
    }
end

local text = 'hello, this is a test of a large text box'
local textbox = CreateFixed(0, 0, 200, 80, text)

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = true,
        resizable = true
    })
end

function love.update(dt)
    textbox:Update(dt)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        textbox:OnClick()
    end
end

function love.draw()
    push:apply('start')
    textbox:Render()
    push:apply('end')
end

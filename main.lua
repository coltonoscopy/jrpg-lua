require 'ui/Panel'
require 'ui/Textbox'
push = require 'push'

virtualWidth = 384
virtualHeight = 216

function CreateFixed(x, y, width, height, text, params)
    params = params or {}
    local avatar = params.avatar
    local title = params.title

    local padding = 10
    local textScale = 1.5
    local panelTileSize = 3

    local wrap = width - padding
    local boundsTop = padding
    local boundsLeft = padding

    local children = {}

    if avatar then
        boundsLeft = avatar:getWidth() + padding * 2
        wrap = width - (boundsLeft) - padding
        local sprite = Sprite:Create()
        sprite:SetTexture(avatar)
        table.insert(children,
        {
            type = 'sprite',
            sprite = sprite,
            x = avatar:getWidth() / 2 + padding,
            y = avatar:getHeight() / 2
        })
    end

    if title then
        -- adjust the top
        local size = love.graphics.getFont():getHeight()
        boundsTop = size + padding * 2

        table.insert(children,{
            type = 'text',
            text = title,
            x = 0,
            y = -size - padding
        })
    end

    return Textbox:Create {
        text = text,
        textScale = textScale,
        size = {
            left = x - width / 2,
            right = x + width / 2,
            top = y - height / 2,
            bottom = y + height / 2,
        },
        textbounds = {
            left = boundsLeft,
            right = -padding,
            top = -boundsTop,
            bottom = padding
        },
        panelArgs = {
            texture = 'graphics/gradient_panel.png',
            size = panelTileSize
        },
        children = children,
        wrap = wrap
    }
end

local text = "It's dangerous to go alone! Take this."
local textbox = CreateFixed(0, 0, virtualWidth-3, 100, text, {
    title = 'Charles:',
    avatar = love.graphics.newImage('graphics/avatar.png')
})

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

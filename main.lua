-- Callbacks for key pressed, in case we spread over multiple files
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

require 'ui/Panel'
require 'ui/ProgressBar'
require 'ui/Scrollbar'
require 'ui/Selection'
require 'ui/Textbox'
push = require 'push'

virtualWidth = 384
virtualHeight = 216

love.graphics.setFont(love.graphics.newFont('fonts/04B_03__.TTF', 8))

local width = virtualWidth - 4
local height = 102
local x = 0
local y = 0
local text = 'Should I join your party?'
local title = 'NPC:'
local avatar = love.graphics.newImage('graphics/avatar.png')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = false,
        resizable = true
    })
end

function CreateFixed(x, y, width, height, text, params)
    params = params or {}
    local avatar = params.avatar
    local title = params.title
    local choices = params.choices

    local padding = 10
    local textScale = 1.5
    local panelTileSize = 3

    local wrap = width - padding * 2
    local boundsTop = padding
    local boundsLeft = padding
    local boundsBottom = padding

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

    local selectionMenu = nil
    if choices then
        -- options and callback
        selectionMenu = Selection:Create {
            data = choices.options,
            OnSelection = choices.OnSelection,
            textScale = choices.textScale
        }
        boundsBottom = boundsBottom - padding * 0.5
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

    -- Temp scaled font to get proper wrapping measurements
    local scaledFont = love.graphics.newFont('fonts/04B_03__.TTF',
        love.graphics.getFont():getHeight() * textScale)
    local faceHeight = scaledFont:getHeight()
    local textWidth, lines = scaledFont:getWrap(text, wrap)

    local boundsHeight = height - (boundsBottom + boundsTop)
    local currentHeight = faceHeight

    local lineCounter = 1
    local chunks = {{lines[lineCounter]}}
    while lineCounter <= #lines do
        lineCounter = lineCounter + 1

        -- If we're going to overflow
        if (currentHeight + faceHeight) > boundsHeight then
            -- make a new entry
            currentHeight = 0
            table.insert(chunks, {lines[lineCounter]})
        else
            table.insert(chunks[#chunks], lines[lineCounter])
        end
        currentHeight = currentHeight + faceHeight
    end

    -- Make each textbox be represented by one string.
    for k, v in ipairs(chunks) do
        chunks[k] = table.concat(v)
    end

    return Textbox:Create {
        text = chunks,
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
        wrap = wrap,
        selectionMenu = selectionMenu
    }
end

function CreateFitted(x, y, text, wrap, params)
    local params = params or {}
    local choices = params.choices
    local title = params.title
    local avatar = params.avatar

    local padding = 10
    local panelTileSize = 3
    local textScale = 1.5

    local scaledFont = love.graphics.newFont('fonts/04B_03__.TTF',
        love.graphics.getFont():getHeight() * textScale)
    local size = scaledFont:getWidth(text)
    local width = size + padding * 2
    local height = scaledFont:getHeight() + padding * 2

    if choices then
        -- options and callback
        local selectionMenu = Selection:Create {
            data = choices.options,
            displayRows = #choices.options,
            columns = 1
        }
        height = height + selectionMenu:GetHeight() + padding * 4
        width = math.max(width, selectionMenu:GetWidth() + padding * 2)
    end

    if title then
        height = height + scaledFont:getHeight() + padding
        width = math.max(width, size + padding)
    end

    if avatar then
        local avatarWidth = avatar:getWidth()
        local avatarHeight = avatar:getHeight()
        width = width + avatarWidth + padding
        height = math.max(height, avatarHeight + padding)
    end

    return CreateFixed(x, y, width, height, text, params)
end

local textbox = CreateFitted(0, 0, text, 300, {
    title = title,
    avatar = avatar
})

gLastSelection = '?'

local bar = ProgressBar:Create {
    x = 0,
    y = 0,
    value = 1,
    foreground = love.graphics.newImage('graphics/foreground.png'),
    background = love.graphics.newImage('graphics/background.png')
}

local tween = Tween:Create(1, 0, 1)

local bar1 = Scrollbar:Create('graphics/scrollbar.png', 100)
local bar2 = Scrollbar:Create('graphics/scrollbar.png', 200)
local bar3 = Scrollbar:Create('graphics/scrollbar.png', 75)

bar1:SetScrollCaretScale(0.5)
bar1:SetNormalValue(0.5)
bar1:SetPosition(-50, 0)

bar2:SetScrollCaretScale(0.3)
bar2:SetNormalValue(0)
bar2:SetPosition(0, 0)

bar3:SetScrollCaretScale(0.1)
bar3:SetNormalValue(1)
bar3:SetPosition(50, -0)

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
    bar1:Render()
    bar2:Render()
    bar3:Render()
    push:apply('end')
end

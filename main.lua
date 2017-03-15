-- Callbacks for key pressed, in case we spread over multiple files
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

require 'ui/Panel'
require 'ui/Selection'
require 'ui/Textbox'
push = require 'push'

virtualWidth = 384
virtualHeight = 216

love.graphics.setFont(love.graphics.newFont('fonts/04B_03__.TTF', 8))

local width = virtualWidth - 4
local height = 102
local x = 0
local y = height / 2
local text = [['A nation can survive its fools, and even the ambitious. But it cannot survive treason from within. An enemy at the gates is less formidable, for he is known and carries his banner openly. But the traitor moves amongst those within the gate freely, his sly whispers rustling through all the alleys, heard in the very halls of government itself. For the traitor appears not a traitor; he speaks in accents familiar to his victims, and he wears their face and their arguments, he appeals to the baseness that lies deep in the hearts of all men. He rots the soul of a nation, he works secretly and unknown in the night to undermine the pillars of the city, he infects the body politic so that it can no longer resist. A murderer is less to fear.']]
local title = 'NPC:'
local avatar = love.graphics.newImage('graphics/avatar.png')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = true,
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
            OnSelection = choices.OnSelection
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

    for k, v in pairs(lines) do
        print(k, v)
    end

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

local textbox = CreateFixed(x, y, width, height, text, title, avatar)

gLastSelection = '?'
gChoice = Selection:Create {
    data = {
        'Yes',
        'No'
    },
    cursor = 'graphics/cursor.png',
    OnSelection = function(selectIndex)
        gLastSelection = selectIndex
    end
}

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
    -- textbox:Update(dt)
    gChoice:HandleInput()
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

    -- if key == 'space' then
    --     textbox:OnClick()
    -- end
    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.draw()
    push:apply('start')
    -- textbox:Render()
    love.graphics.print('Last selection: ' .. tostring(gLastSelection),
        virtualWidth / 2, virtualHeight / 2 + 50)
    gChoice:Render()
    push:apply('end')
end

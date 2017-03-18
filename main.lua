-- Callbacks for key pressed, in case we spread over multiple files
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

require 'ui/Layout'
require 'ui/Panel'
require 'ui/ProgressBar'
require 'ui/Scrollbar'
require 'ui/Selection'
require 'ui/Textbox'
push = require 'push'

require 'code/states/ExploreState'
require 'code/states/FadeState'
require 'code/states/FrontMenuState'
require 'code/states/InGameMenuState'
require 'code/states/WaitState'
require 'code/states/MoveState'
require 'code/states/NPCStandState'
require 'code/states/PlanStrollState'

require 'Character'
require 'Entity'
require 'EntityDefs'
require 'ItemDB'
require 'small_room'
require 'Map'
require 'StateMachine'
require 'StateStack'
require 'Vector'
require 'World'

virtualWidth = 384
virtualHeight = 216

gWorld = World:Create()

love.graphics.setFont(love.graphics.newFont('fonts/04B_03__.TTF', 8))

local itemList = Selection:Create {
    data = gWorld.mItems,
    spacingY = 32,
    rows = 5,
    RenderItem = function(menu, x, y, item)
        if item then
            local itemDef = ItemDB[item.id]
            local label = string.format('%s (%d)',
                                        itemDef.name,
                                        item.count)
            love.graphics.print(label, x, y)
        else
            love.graphics.print('--', x, y)
        end
    end
}

local keyItemList = Selection:Create {
    data = gWorld.mKeyItems,
    spacingY = 32,
    rows = 5,
    RenderItem = function(menu, x, y, item)
        if item then
            local itemDef = ItemDB[item.id]
            love.graphics.print(itemDef.name, x, y)
        else
            love.graphics.print('--', x, y)
        end
    end
}
keyItemList:HideCursor()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = false,
        resizable = true
    })

    print('Game loaded!')
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
    gWorld:Update(dt)
    itemList:HandleInput()
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

    if key == 'tab' then
        love.load()
    end

    if key == 'a' then
        gWorld:AddItem(1)
    end

    if key == 'r' then
        local item = itemList:SelectedItem()
        if item then
            gWorld:RemoveItem(item.id)
        end
    end

    if key == 'k' then
        if not gWorld:HasKey(4) then
            gWorld:AddKey(4)
        end
    end

    if key == 'u' then
        if gWorld:HasKey(4) then
            gWorld:RemoveKey(4)
        end
    end

    if key == 'g' then
        gWorld.mGold = gWorld.mGold + math.random(100)
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.draw()
    push:apply('start')
    local x = 30
    local y = 50
    love.graphics.printf('ITEMS', x, y - 32,
        itemList:GetWidth() * 1.5, 'center', 0, 1, 1)
    itemList:SetPosition(x, y)
    itemList:Render()

    x = virtualWidth - 150

    love.graphics.printf('KEY ITEMS', x, math.floor(y - 32),
        itemList:GetWidth() * 1.5, 'center', 0, 1, 1)
    keyItemList:SetPosition(x, y)
    keyItemList:Render()

    local timeText = string.format('TIME:%s', gWorld:TimeAsString())
    local goldText = string.format('GOLD:%s', gWorld:GoldAsString())
    love.graphics.printf(timeText, 0, 10, virtualWidth, 'center', 0, 1, 1)
    love.graphics.printf(goldText, 0, 20, virtualWidth, 'center', 0, 1, 1)

    local tip = 'A - Add Item, R - Remove Item, ' ..
                'K - Add Key, U - Use Key, G - Add Gold'
    love.graphics.printf(tip, 0, virtualHeight - 20, virtualWidth, 'center', 0, 1, 1)
    push:apply('end')
end

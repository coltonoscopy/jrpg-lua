-- require("maps/larger_map")
require('maps/small_room')

require('Actions')
require('Animation')
require('Character')
require('Entity')
require('Map')
require('Trigger')

require('StateMachine')
require('code/states/MoveState')
require('code/states/NPCStandState')
require('code/states/PlanStrollState')
require('code/states/WaitState')
require('Tween')

require('EntityDefs')

local displayWidth
local displayHeight

-- virtual resolution coords
virtualWidth = nil
virtualHeight = nil

local canvas
local font
local tileSprite

function Teleport(entity, map)
    local x, y = map:GetTileFoot(entity.mTileX, entity.mTileY)
    entity.mX = x
    entity.mY = y
end

local mapDef = CreateMap1()
mapDef.on_wake = {
    {
        id = 'AddNPC',
        params = {{def = 'strolling_npc', x = 11, y = 5}}
    },
    {
        id = 'AddNPC',
        params = {{def = 'standing_npc', x = 4, y = 5}}
    }
}
mapDef.actions = {
    tele_south = {id = 'Teleport', params = {11, 3}},
    tele_north = {id = 'Teleport', params = {10, 11}}
}
mapDef.trigger_types = {
    north_door_trigger = {OnEnter = 'tele_south'},
    south_door_trigger = {OnEnter = 'tele_north'}
}
mapDef.triggers = {
    { trigger = 'north_door_trigger', x = 11, y = 2 },
    { trigger = 'south_door_trigger', x = 10, y = 12 }
}
local gMap = Map:Create(mapDef)
gHero = Character:Create(gCharacters.hero, gMap)

function love.load()
    love.window.setFullscreen(true)
    displayWidth = love.graphics.getWidth()
    displayHeight = love.graphics.getHeight()

    virtualWidth = displayWidth / 4
    virtualHeight = displayHeight / 4

    canvas = love.graphics.newCanvas(virtualWidth, virtualHeight)
    canvas:setFilter("nearest", "nearest")

    font = love.graphics.newFont("fonts/Altima.ttf", 16)
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    gMap:GotoTile(5, 5)
end

function GetFacedTileCoords(character)
    -- Change the facing information into a tile offset
    local xInc = 0
    local yInc = 0

    if character.mFacing == 'left' then
        xInc = -1
    elseif character.mFacing == 'right' then
        xInc = 1
    elseif character.mFacing == 'up' then
        yInc = -1
    elseif character.mFacing == 'down' then
        yInc = 1
    end

    local x = character.mEntity.mTileX + xInc
    local y = character.mEntity.mTileY + yInc

    return x, y
end

gUpDoorTeleport = Actions.Teleport(gMap, 11, 3)
gDownDoorTeleport = Actions.Teleport(gMap, 10, 11)
gHero.mEntity:SetTilePos(11, 3, 1, gMap)

gTriggerTop = Trigger:Create {
    OnEnter = gDownDoorTeleport
}

gTriggerBot = Trigger:Create {
    OnEnter = gUpDoorTeleport
}

gMap.mTriggers = {
    {
        [gMap:CoordToIndex(10, 12)] = gTriggerBot,
        [gMap:CoordToIndex(11, 2)] = gTriggerTop
    }
}

function love.update(dt)
    gMap.mCamX = math.floor(gHero.mEntity.mX - virtualWidth / 2 + gHero.mEntity.mWidth / 2)
    gMap.mCamY = math.floor(gHero.mEntity.mY - virtualHeight / 2 + gHero.mEntity.mHeight / 2)

    gHero.mController:Update(dt)

    for k, v in ipairs(gMap.mNPCs) do
        v.mController:Update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        -- which way is the player facing?
        local x, y = GetFacedTileCoords(gHero)
        local trigger = gMap:GetTrigger(gHero.mEntity.mLayer, x, y)
        if trigger then
            trigger:OnUse(gHero)
        end
    end
end

function love.draw()
    love.graphics.translate(-gMap.mCamX, -gMap.mCamY)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        local layerCount = gMap:LayerCount()
        for i = 1, layerCount do
            local heroEntity = nil
            if i == gHero.mEntity.mLayer then
                heroEntity = gHero.mEntity
            end

            gMap:RenderLayer(i, heroEntity)
        end
    love.graphics.setCanvas()

    love.graphics.draw(canvas, gMap.mCamX, gMap.mCamY, 0,
        displayWidth / virtualWidth)
end

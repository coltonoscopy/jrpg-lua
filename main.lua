-- require("maps/larger_map")
require('maps/small_room')

require('Actions')
require('Animation')
require('Entity')
require('Map')
require('Trigger')

require('StateMachine')
require('code/states/MoveState')
require('code/states/WaitState')
require('Tween')

local displayWidth
local displayHeight

-- virtual resolution coords
virtualWidth = nil
virtualHeight = nil

local canvas
local font
local tileSprite

local gMap = Map:Create(CreateMap1())

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

local heroDef = {
    texture     = 'graphics/walk_cycle.png',
    width       = 16,
    height      = 24,
    startFrame  = 9,
    tileX       = 11,
    tileY       = 3,
    layer       = 1
}

local gHero
gHero = {
    mAnimUp = {1, 2, 3, 4},
    mAnimRight = {5, 6, 7, 8},
    mAnimDown = {9, 10, 11, 12},
    mAnimLeft = {13, 14, 15, 16},
    mEntity = Entity:Create(heroDef),
    Init =
    function(self)
        self.mController = StateMachine:Create {
            ['wait'] = function() return self.mWaitState end,
            ['move'] = function() return self.mMoveState end
        }
        self.mWaitState = WaitState:Create(self, gMap)
        self.mMoveState = MoveState:Create(self, gMap)
        self.mController:Change('wait')
    end
}
gHero:Init()

function Teleport(entity, map)
    local x, y = map:GetTileFoot(entity.mTileX, entity.mTileY)
    entity.mX = x
    entity.mY = y
end

gUpDoorTeleport = Actions.Teleport(gMap, 11, 3)
gDownDoorTeleport = Actions.Teleport(gMap, 10, 11)
gUpDoorTeleport(nil, gHero.mEntity)

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
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        gUpDoorTeleport(nil, gHero.mEntity)
    end
end

function love.draw()
    love.graphics.translate(-gMap.mCamX, -gMap.mCamY)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        local layerCount = gMap:LayerCount()
        for i = 1, layerCount do
            gMap:RenderLayer(i)

            if i == gHero.mEntity.mLayer then
                love.graphics.draw(gHero.mEntity.mSpritesheet['sheet'], gHero.mEntity.mFrame,
                    gHero.mEntity.mX, gHero.mEntity.mY, 0, 1, 1)
            end
        end
    love.graphics.setCanvas()

    love.graphics.draw(canvas, gMap.mCamX, gMap.mCamY, 0,
        displayWidth / virtualWidth)
end

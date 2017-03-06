-- require("maps/larger_map")
require('maps/small_room')
require('Entity')
require("Map")

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
    tileX       = 10,
    tileY       = 2
}

local gHero
gHero = {
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

Teleport(gHero.mEntity, gMap)

function love.update(dt)
    if love.keyboard.isDown('up') then
        gMap.mCamY = gMap.mCamY - 1
    elseif love.keyboard.isDown('down') then
        gMap.mCamY = gMap.mCamY + 1
    end

    if love.keyboard.isDown('left') then
        gMap.mCamX = gMap.mCamX - 1
    elseif love.keyboard.isDown('right') then
        gMap.mCamX = gMap.mCamX + 1
    end

    gHero.mController:Update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.translate(-gMap.mCamX, -gMap.mCamY)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        gMap:Render()
        love.graphics.draw(gHero.mEntity.mSpritesheet['sheet'], gHero.mEntity.mFrame,
            gHero.mEntity.mX, gHero.mEntity.mY, 0, 1, 1)
    love.graphics.setCanvas()

    love.graphics.draw(canvas, gMap.mCamX, gMap.mCamY, 0,
        displayWidth / virtualWidth)
end

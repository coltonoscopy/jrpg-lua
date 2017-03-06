-- require("maps/larger_map")
require('maps/small_room')
require('Entity')
require("Map")

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

gHero = Entity:Create(heroDef)

function love.update()
    gHero.mX, gHero.mY = gMap:GetTileFoot(gHero.mTileX, gHero.mTileY)

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
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'w' then
        gHero.mTileY = gHero.mTileY - 1
    elseif key == 's' then
        gHero.mTileY = gHero.mTileY + 1
    end

    if key == 'a' then
        gHero.mTileX = gHero.mTileX - 1
    elseif key == 'd' then
        gHero.mTileX = gHero.mTileX + 1
    end
end

function love.draw()
    love.graphics.translate(-gMap.mCamX, -gMap.mCamY)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        gMap:Render()
        love.graphics.draw(gHero.mSpritesheet['sheet'], gHero.mFrame,
            gHero.mX, gHero.mY, 0, 1, 1)
    love.graphics.setCanvas()

    love.graphics.draw(canvas, gMap.mCamX, gMap.mCamY, 0,
        displayWidth / virtualWidth)
end

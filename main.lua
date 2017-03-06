-- require("maps/larger_map")
require('maps/small_room')
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

local heroWidth = 16
local heroHeight = 24
gHeroSprites = LoadSpritesheet('graphics/walk_cycle.png', heroWidth, heroHeight)
gHeroFrame = gHeroSprites[9]
gHeroTileX = 10
gHeroTileY = 2
local x, y = gMap:GetTileFoot(gHeroTileX, gHeroTileY)

function love.update()
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
end

function love.draw()
    love.graphics.translate(-gMap.mCamX, -gMap.mCamY)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        gMap:Render()
        love.graphics.draw(gHeroSprites['sheet'], gHeroFrame, x, y, 0, 1, 1)
    love.graphics.setCanvas()

    love.graphics.draw(canvas, gMap.mCamX, gMap.mCamY, 0,
        displayWidth / virtualWidth)
end

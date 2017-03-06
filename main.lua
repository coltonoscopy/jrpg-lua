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
    love.graphics.setCanvas()

    love.graphics.draw(canvas, gMap.mCamX, gMap.mCamY, 0,
        displayWidth / virtualWidth)
end

local displayWidth
local displayHeight

-- virtual resolution coords
local virtualWidth
local virtualHeight

local canvas
local font
local tileSprite

local tilesPerRow
local tilesPerColumn

local tileWidth
local tileHeight

function love.load()
    love.window.setFullscreen(true)
    displayWidth = love.graphics.getWidth()
    displayHeight = love.graphics.getHeight()

    virtualWidth = displayWidth / 6
    virtualHeight = displayHeight / 6

    canvas = love.graphics.newCanvas(virtualWidth, virtualHeight)
    canvas:setFilter("nearest", "nearest")

    font = love.graphics.newFont("fonts/Altima.ttf", 16)
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    tileSprite = love.graphics.newImage("graphics/grass_tile.png")
    tileWidth = tileSprite:getWidth()
    tileHeight = tileSprite:getHeight()

    tilesPerRow = math.ceil(virtualWidth / tileWidth)
    tilesPerColumn = math.ceil(virtualHeight / tileHeight)
end

function love.draw()
    love.graphics.setCanvas(canvas)
        for j = 0, tilesPerColumn - 1 do
            for i = 0, tilesPerRow - 1 do
                love.graphics.draw(tileSprite, i * tileWidth, j * tileHeight)
            end
        end
    love.graphics.setCanvas()

    love.graphics.draw(canvas, 0, 0, 0, displayWidth / virtualWidth)
end

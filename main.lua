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

gTextures = {
    love.graphics.newImage("graphics/tiles_00.png"),
    love.graphics.newImage("graphics/tiles_01.png"),
    love.graphics.newImage("graphics/tiles_02.png"),
    love.graphics.newImage("graphics/tiles_03.png"),
    love.graphics.newImage("graphics/tiles_04.png"),
    love.graphics.newImage("graphics/tiles_05.png"),
    love.graphics.newImage("graphics/tiles_06.png"),
    love.graphics.newImage("graphics/tiles_07.png"),
    love.graphics.newImage("graphics/tiles_08.png"),
    love.graphics.newImage("graphics/tiles_09.png"),
    love.graphics.newImage("graphics/tiles_10.png"),
}

gSpritesheet = {}

gMap = {
    1, 1, 1, 1, 5, 6, 7, 1,
    1, 1, 1, 1, 5, 6, 7, 1,
    1, 1, 1, 1, 5, 6, 7, 1,
    3, 3, 3, 3, 11, 6, 7, 1,
    9, 9, 9, 9, 9, 9, 10, 1,
    1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 2, 3,
}
gMapWidth = 8
gMapHeight = 7

function GetTile(map, rowsize, x, y)
    x = x + 1
    return map[x + y * rowsize]
end

function LoadSpritesheet()
    local imageFile = love.graphics.newImage('graphics/atlas.png')
    local sheetWidth = imageFile:getWidth() / 32
    local sheetHeight = imageFile:getHeight() / 32

    local sheetCounter = 1
    gSpritesheet['sheet'] = imageFile

    for y = 0, sheetHeight do
        for x = 0, sheetWidth do
            gSpritesheet[sheetCounter] =
                love.graphics.newQuad(x * 32, y * 32, 32, 32, imageFile:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end
end

local topLeftTile = GetTile(gMap, gMapWidth, 0, 0)
local bottomRightTile = GetTile(gMap, gMapWidth,
    gMapWidth - 1, gMapHeight - 1)

function love.load()
    love.window.setFullscreen(true)
    displayWidth = love.graphics.getWidth()
    displayHeight = love.graphics.getHeight()

    LoadSpritesheet()

    virtualWidth = displayWidth / 6
    virtualHeight = displayHeight / 6

    canvas = love.graphics.newCanvas(virtualWidth, virtualHeight)
    canvas:setFilter("nearest", "nearest")

    font = love.graphics.newFont("fonts/Altima.ttf", 16)
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    tileWidth = gTextures[1]:getWidth()
    tileHeight = gTextures[1]:getHeight()

    print("Tile width: " .. tileWidth)

    tilesPerRow = math.ceil(virtualWidth / tileWidth)
    tilesPerColumn = math.ceil(virtualHeight / tileHeight)
end

function love.draw()
    love.graphics.setCanvas(canvas)
        for j = 0, gMapHeight - 1 do
            for i = 0, gMapWidth - 1 do
                local tile = GetTile(gMap, gMapWidth, i, j)
                local activeFrame = gSpritesheet[tile]

                love.graphics.draw(gSpritesheet['sheet'], activeFrame,
                    i * tileWidth, j * tileHeight,
                    0, 1, 1)
            end
        end
    love.graphics.setCanvas()

    love.graphics.draw(canvas, 0, 0, 0, displayWidth / virtualWidth)
end

require("maps/larger_map")

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

gSpritesheet = {}
local tileIndex = 1

gTiledMap = CreateMap1()
gMap = gTiledMap.layers[1]

gMapWidth = gMap.width
gMapHeight = gMap.height
gTiles = gMap.data

tileWidth = gTiledMap.tilewidth
tileHeight = gTiledMap.tileheight

function GetTile(map, rowsize, x, y)
    x = x + 1
    return map[x + y * rowsize]
end

function LoadSpritesheet()
    local imageFile = love.graphics.newImage(gTiledMap.tilesets[1].image)
    local sheetWidth = imageFile:getWidth() / tileWidth
    local sheetHeight = imageFile:getHeight() / tileHeight

    local sheetCounter = 1
    gSpritesheet['sheet'] = imageFile

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            gSpritesheet[sheetCounter] =
                love.graphics.newQuad(x * tileWidth, y * tileWidth, tileWidth,
                tileWidth, imageFile:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end
end

local topLeftTile = GetTile(gTiles, gMapWidth, 0, 0)
local bottomRightTile = GetTile(gTiles, gMapWidth,
    gMapWidth - 1, gMapHeight - 1)

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

    LoadSpritesheet()

    activeFrame = gSpritesheet[tileIndex]

    tileWidth = gTiledMap.tilesets[1].tilewidth
    tileHeight = gTiledMap.tilesets[1].tileheight

    print("Tile width: " .. tileWidth)

    tilesPerRow = math.ceil(virtualWidth / tileWidth)
    tilesPerColumn = math.ceil(virtualHeight / tileHeight)
end

function love.keypressed(key, unicode)
    if key == 'space' then
        tileIndex = tileIndex + 1
        activeFrame = gSpritesheet[tileIndex]
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
        for j = 0, gMapHeight - 1 do
            for i = 0, gMapWidth - 1 do
                local tile = GetTile(gTiles, gMapWidth, i, j)
                activeFrame = gSpritesheet[tile]

                love.graphics.draw(gSpritesheet['sheet'], activeFrame,
                    i * tileWidth, j * tileHeight,
                    0, 1, 1)
            end
        end
    love.graphics.setCanvas()

    love.graphics.draw(canvas, 0, 0, 0, displayWidth / virtualWidth)
end

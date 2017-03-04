local w
local h

-- virtual resolution coords
vw = 320
vh = 180

local canvas
local font
local tileSprite

function love.load()
    love.window.setFullscreen(true)
    w = love.graphics.getWidth()
    h = love.graphics.getHeight()

    canvas = love.graphics.newCanvas(vw, vh)
    canvas:setFilter("nearest", "nearest")

    font = love.graphics.newFont("fonts/Altima.ttf", 16)
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    tileSprite = love.graphics.newImage("graphics/grass_tile.png")
end

function love.draw()
    love.graphics.setCanvas(canvas)
        love.graphics.draw(tileSprite)
    love.graphics.setCanvas()

    love.graphics.draw(canvas, 0, 0, 0, w / vw)
end

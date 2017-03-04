local w
local h

function love.load()
    love.window.setFullscreen(true)
    w = love.graphics.getWidth()
    h = love.graphics.getHeight()

    -- virtual resolution coords
    vw = 320
    vh = 180

    -- draw to render texture for virtual resolution
    canvas = love.graphics.newCanvas(vw, vh)
    canvas:setFilter("nearest", "nearest")
    local font = love.graphics.newFont("Altima.ttf", 16)
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    love.graphics.setCanvas(canvas)
        love.graphics.printf('Hello Butt', 0, vh / 2, vw, "center")
    love.graphics.setCanvas()
end

function love.draw()
    love.graphics.draw(canvas, 0, 0, 0, 6)
end

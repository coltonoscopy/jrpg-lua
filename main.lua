local w
local h

function love.load()
    love.window.setFullscreen(true)
    w = love.graphics.getWidth()
    h = love.graphics.getHeight()
end

function love.draw()
    love.graphics.printf('Hello World', 0, h / 2, w, "center")
end

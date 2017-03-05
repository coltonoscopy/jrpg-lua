function LoadSpritesheet(atlas, tilewidth, tileheight)
    local imageFile = love.graphics.newImage(atlas)
    local sheetWidth = imageFile:getWidth() / tilewidth
    local sheetHeight = imageFile:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}
    spritesheet['sheet'] = imageFile

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tilewidth, imageFile:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

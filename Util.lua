function LoadSpritesheet(atlas, tilewidth, tileheight, filter)
    filter = filter or 'nearest'
    local imageFile = love.graphics.newImage(atlas)
    imageFile:setFilter(filter, filter)
    local sheetWidth = imageFile:getWidth() / tilewidth
    local sheetHeight = imageFile:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}
    spritesheet['sheet'] = imageFile

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, imageFile:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function Apply(list, f, iter)
    iter = iter or pairs
    for k, v in iter(list) do
        f(v, k)
    end
end

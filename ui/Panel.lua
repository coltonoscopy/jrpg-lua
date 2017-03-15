require 'Sprite'
require 'Util'

Panel = {}
Panel.__index = Panel

function Panel:Create(params)
    local this = {
        mTexture = params.texture,
        mSpritesheet = LoadSpritesheet(params.texture, params.size, params.size),
        mTileSize = params.size,
        mTiles = {}, -- the sprites representing the border.
    }

    -- Create a sprite for each tile of the panel
    -- 1. top left      2. top          3. top right
    -- 4. left          5. middle       6. right
    -- 7. bottom left   8. bottom       9. bottom right
    for k, v in ipairs(this.mSpritesheet) do
        if k ~= 'sheet' then
            local sprite = Sprite:Create()
            sprite:SetTexture(this.mSpritesheet['sheet'])
            sprite:SetQuad(this.mSpritesheet[k])
            this.mTiles[k] = sprite
        end
    end

    -- Fix up center UVs by moving them 0.5 texels in
    local centerQuad = this.mSpritesheet[5]
    x, y, w, h = centerQuad:getViewport()
    centerQuad:setViewport(x + 0.5, y + 0.5, w - 1, h - 1)

    setmetatable(this, self)
    return this
end

function Panel:Position(left, top, right, bottom)

    -- Reset scales
    for _, v in ipairs(self.mTiles) do
        v:SetScale(1, 1)
    end

    -- print(left, top, right, bottom)

    local hSize = math.floor(self.mTileSize / 2 + 0.5)

    -- align the corner tiles
    self.mTiles[1]:SetPosition(left - hSize, top - hSize)
    self.mTiles[3]:SetPosition(right - hSize, top - hSize)
    self.mTiles[7]:SetPosition(left - hSize, bottom - hSize)
    self.mTiles[9]:SetPosition(right - hSize, bottom - hSize)

    -- Calculate how much to scale the side tiles
    local widthScale = ((math.abs(right - left)) - hSize - 1)
        / self.mTileSize

    self.mTiles[2]:SetPosition(left + 1, top - hSize)
    self.mTiles[2]:SetScale(widthScale, 1)

    self.mTiles[8]:SetPosition(left + 1, bottom - hSize)
    self.mTiles[8]:SetScale(widthScale, 1)

    local heightScale = ((math.abs(bottom - top)) - hSize - 1)
        / self.mTileSize

    self.mTiles[4]:SetScale(1, heightScale)
    self.mTiles[4]:SetPosition(left - hSize, top + 1)

    self.mTiles[6]:SetScale(1, heightScale)
    self.mTiles[6]:SetPosition(right - hSize, top + 1)

    -- Scale the middle backing panel
    self.mTiles[5]:SetPosition(left + hSize - 1, top + hSize - 1)
    self.mTiles[5]:SetScale(widthScale * 1.5, heightScale * 1.5)

    -- Hide corner tiles when scale is equal to zero
    if left - right == 0 or top - bottom == 0 then
        for _, v in ipairs(self.mTiles) do
            v:SetScale(0, 0)
        end
    end
end

function Panel:CenterPosition(x, y, width, height)
    local hWidth = width / 2
    local hHeight = height / 2
    return self:Position(x - hWidth, y - hHeight,
                         x + hWidth, y + hHeight)
end

function Panel:Render()
    for k, v in ipairs(self.mTiles) do
        v:Render()
    end
end

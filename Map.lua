require('Util')

Map = {}
Map.__index = Map

function Map:Create(mapDef)
    local layer = mapDef.layers[1]
    local this = {
        mX = 0,
        mY = 0,

        -- To track camera position
        mCamX = 0,
        mCamY = 0,

        mMapDef = mapDef,
        mTextureAtlas = love.graphics.newImage(mapDef.tilesets[1].image),

        mTileSprite = nil,
        mLayer = layer,
        mWidth = layer.width,
        mHeight = layer.height,

        mTiles = layer.data,
        mTileWidth = mapDef.tilesets[1].tilewidth,
        mTileHeight = mapDef.tilesets[1].tileheight,

        mSpritesheet = LoadSpritesheet(mapDef.tilesets[1].image,
            mapDef.tilesets[1].tilewidth, mapDef.tilesets[1].tileheight),
    }

    -- top left corner of the map
    this.mX = 0
    this.mY = 0

    -- additional fields
    this.mWidthPixel = this.mWidth * this.mTileWidth
    this.mHeightPixel = this.mHeight * this.mTileHeight

    setmetatable(this, self)
    return this
end

function Map:PointToTile(x, y)
    x = math.max(self.mX, x)
    y = math.max(self.mY, y)

    x = math.min(x, self.mWidthPixel)
    y = math.min(y, self.mHeightPixel)

    local tileX = math.floor(x / self.mTileWidth)
    local tileY = math.floor(y / self.mTileHeight)

    return tileX, tileY
end

function Map:GetTile(x, y)
    x = x + 1
    return self.mTiles[x + y * self.mWidth]
end

function Map:Render()
    local tileLeft, tileTop =
        self:PointToTile(self.mCamX, self.mCamY)

    local tileRight, tileBottom =
        self:PointToTile(self.mCamX + virtualWidth, self.mCamY + virtualHeight)

    for j = tileTop, tileBottom do
        for i = tileLeft, tileRight do
            local tile = self:GetTile(i, j)
            local activeFrame = self.mSpritesheet[tile]
            love.graphics.draw(self.mSpritesheet['sheet'], activeFrame,
                self.mX + i * self.mTileWidth, self.mY + j * self.mTileHeight,
                0, 1, 1)
        end
    end
end

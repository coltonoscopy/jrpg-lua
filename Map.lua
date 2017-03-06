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

    -- assign blocking tile id
    for _, v in ipairs(mapDef.tilesets) do
        if v.name == 'collision_graphic' then
            this.mBlockingTile = v.firstgid
        end
    end

    assert(this.mBlockingTile)
    setmetatable(this, self)
    return this
end

function Map:PointToTile(x, y)
    x = math.max(self.mX, x)
    y = math.max(self.mY, y)

    x = math.min(x, self.mWidthPixel - 1)
    y = math.min(y, self.mHeightPixel - 1)

    local tileX = math.floor(x / self.mTileWidth)
    local tileY = math.floor(y / self.mTileHeight)

    return tileX, tileY
end

function Map:GetTile(x, y, layer)
    local layer = layer or 1
    local tiles = self.mMapDef.layers[layer].data
    x = x + 1
    return tiles[x + y * self.mWidth]
end

function Map:IsBlocked(layer, tileX, tileY)
    -- collision layer should always be 1 above the official layer
    local tile = self:GetTile(tileX, tileY, layer + 2)
    return tile == self.mBlockingTile
end

function Map:Render()
    self:RenderLayer(1)
end

function Map:RenderLayer(layer)
    -- Our maps layers are made of 3 sections
    -- We want the index to point to the base section of a given layer
    local layerIndex = (layer * 3) - 2

    local tileLeft, tileTop =
        self:PointToTile(self.mCamX, self.mCamY)

    local tileRight, tileBottom =
        self:PointToTile(self.mCamX + virtualWidth - 1, self.mCamY + virtualHeight - 1)

    for j = tileTop, tileBottom do
        for i = tileLeft, tileRight do
            local tile
            if j >= 0 and i >= 0 then
                tile = self:GetTile(i, j, layerIndex)
            end

            -- first layer
            if tile > 0 then
                print(tile)
                local activeFrame = self.mSpritesheet[tile]
                love.graphics.draw(self.mSpritesheet['sheet'], activeFrame,
                    self.mX + i * self.mTileWidth, self.mY + j * self.mTileHeight,
                    0, 1, 1)
            end

            -- second layer (decoration)
            tile = self:GetTile(i, j, layerIndex + 1)

            if tile > 0 then
                local activeFrame = self.mSpritesheet[tile]
                love.graphics.draw(self.mSpritesheet['sheet'], activeFrame,
                    self.mX + i * self.mTileWidth, self.mY + j * self.mTileHeight,
                    0, 1, 1)
            end
        end
    end
end

function Map:Goto(x, y)
    self.mCamX = math.floor(x - virtualWidth / 2)
    self.mCamY = math.floor(y - virtualHeight / 2)
end

function Map:GotoTile(x, y)
    self:Goto((x * self.mTileWidth) + self.mTileWidth / 2,
              (y * self.mTileHeight) + self.mTileHeight / 2)
end

function Map:GetTileFoot(x, y)
    return self.mX + (x * self.mTileWidth),
           self.mY + (y * self.mTileHeight) - self.mTileHeight / 2
end

function Map:LayerCount()
    -- Number of layers should be a factor of 3
    assert(#self.mMapDef.layers % 3 == 0)
    return #self.mMapDef.layers / 3
end

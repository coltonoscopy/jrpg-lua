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
        mTriggers = {},
        mEntities = {},
        mNPCs = {},

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

    -- create the actions from the def
    this.mActions = {}
    for name, def in pairs(mapDef.actions or {}) do
        -- look up the action and create the action-function
        -- the action takes in the map as the first param
        assert(Actions[def.id])
        local action = Actions[def.id](this, unpack(def.params))
        this.mActions[name] = action
    end

    -- create the trigger types from the def
    this.mTriggerTypes = {}
    for k, v in pairs(mapDef.trigger_types or {}) do
        local triggerParams = {}
        for callback, action in pairs(v) do
            print(callback, action)
            triggerParams[callback] = this.mActions[action]
            assert(triggerParams[callback])
        end
        this.mTriggerTypes[k] = Trigger:Create(triggerParams)
    end

    setmetatable(this, self)

    -- place any triggers on the map
    this.mTriggers = {}
    for k, v in ipairs(mapDef.triggers) do
        local x = v.x
        local y = v.y
        local layer = v.layer or 1

        if not this.mTriggers[layer] then
            this.mTriggers[layer] = {}
        end

        local targetLayer = this.mTriggers[layer]
        local trigger = this.mTriggerTypes[v.trigger]
        assert(trigger)
        targetLayer[this:CoordToIndex(x, y)] = trigger
    end

    for _, v in ipairs(mapDef.on_wake or {}) do
        local action = Actions[v.id]
        action(this, unpack(v.params))()
    end

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

    return tiles[self:CoordToIndex(x, y)]
end

function Map:CoordToIndex(x, y)
    x = x + 1

    return x + y * self.mWidth
end

function Map:GetEntity(x, y, layer)
    if not self.mEntities[layer] then
        return nil
    end
    local index = self:CoordToIndex(x, y)
    return self.mEntities[layer][index]
end

function Map:AddEntity(entity)
    -- add the layer if it doesn't exist
    if not self.mEntities[entity.mLayer] then
        self.mEntities[entity.mLayer] = {}
    end

    local layer = self.mEntities[entity.mLayer]
    local index = self:CoordToIndex(entity.mTileX, entity.mTileY)

    assert(layer[index] == entity or layer[index] == nil)
    layer[index] = entity
end

function Map:RemoveEntity(entity)
    -- the layer should exist!
    assert(self.mEntities[entity.mLayer])
    local layer = self.mEntities[entity.mLayer]
    local index = self:CoordToIndex(entity.mTileX, entity.mTileY)
    -- the entity should be at the position
    assert(entity == layer[index])
    layer[index] = nil
end

function Map:GetTrigger(layer, x, y)
    -- Gets the triggers on the same layer as the entity
    local triggers = self.mTriggers[layer]

    if not triggers then
        return
    end

    local index = self:CoordToIndex(x, y)
    return triggers[index]
end

function Map:IsBlocked(layer, tileX, tileY)
    -- collision layer should always be 1 above the official layer
    local tile = self:GetTile(tileX, tileY, layer + 2)
    local entity = self:GetEntity(tileX, tileY, layer)

    return tile == self.mBlockingTile or entity ~= nil
end

function Map:Render()
    self:RenderLayer(1)
end

function Map:RenderLayer(layer, hero)
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

        local entLayer = self.mEntities[layer] or {}
        local drawList = {hero}

        for _, j in pairs(entLayer) do
            table.insert(drawList, j)
        end

        table.sort(drawList, function(a, b) return a.mTileY < b.mTileY end)
        for _, ent in ipairs(drawList) do
            ent:Render()
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

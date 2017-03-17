ExploreState = {}
ExploreState.__index = ExploreState

function ExploreState:Create(stack, mapDef, startPos)
    local this = {
        mStack = stack,
        mMapDef = mapDef,
    }

    this.mMap = Map:Create(this.mMapDef)
    this.mHero = Character:Create(gCharacters.hero, this.mMap)
    this.mHero.mEntity:SetTilePos(
        startPos:X(),
        startPos:Y(),
        startPos:Z(), this.mMap)
    this.mHero.mEntity.mSprite:SetPosition(startPos:X() * this.mMap.mTileWidth,
        startPos:Y() * this.mMap.mTileHeight - this.mMap.mTileHeight / 2)

    setmetatable(this, self)
    return this
end

function ExploreState:Enter() end
function ExploreState:Exit() end

function ExploreState:Update(dt)
    local hero = self.mHero
    local map = self.mMap

    -- Update the camera according to player position
    local playerPos = hero.mEntity.mSprite:GetPosition()
    map.mCamX = math.floor(playerPos:X() - virtualWidth + hero.mEntity.mSprite:GetWidth())
    map.mCamY = math.floor(playerPos:Y() - virtualHeight + hero.mEntity.mSprite:GetHeight())

    hero.mController:Update(dt)
    for k, v in ipairs(map.mNPCs) do
        v.mController:Update(dt)
    end
end

function ExploreState:Render()
    local hero = self.mHero
    local map = self.mMap

    love.graphics.push()
    love.graphics.translate(-map.mCamX, -map.mCamY)
    local layerCount = map:LayerCount()

    for i = 1, layerCount do
        local heroEntity = nil
        if i == hero.mEntity.mLayer then
            heroEntity = hero.mEntity
        end
        map:RenderLayer(i, heroEntity)
    end
    love.graphics.pop()
end

function ExploreState:HandleInput()
    if love.keyboard.wasPressed('space') then
        -- which way is the player facing?
        local x, y = self.mHero:GetFacedTileCoords()
        local layer = self.mHero.mEntity.mLayer
        local trigger = self.mMap:GetTrigger(layer, x, y)
        if trigger then
            trigger:OnUse(self.mHero)
        end
    end
end

require('Util')

Entity = {}
Entity.__index = Entity

function Entity:Create(def)
    local this = {
        mX = 0,
        mY = 0,
        mFrame = nil,
        mTexture = def.texture,
        mHeight = def.height,
        mWidth = def.width,
        mTileX = def.tileX,
        mTileY = def.tileY,
        mLayer = def.layer,
        mStartFrame = def.startFrame
    }

    this.mSpritesheet = LoadSpritesheet(this.mTexture, this.mWidth, this.mHeight)
    setmetatable(this, self)
    this:SetFrame(this.mStartFrame)
    return this
end

function Entity:SetFrame(frame)
    self.mFrame = self.mSpritesheet[frame]
end

function Entity:SetTilePos(x, y, layer, map)
    -- remove from current tile
    if map:GetEntity(self.mTileX, self.mTileY, self.mLayer) == self then
        map:RemoveEntity(self)
    end

    -- check target tile
    if map:GetEntity(x, y, layer, map) ~= nil then
        assert(false) -- there's something in the target position!
    end

    self.mTileX = x or self.mTileX
    self.mTileY = y or self.mTileY
    self.mLayer = layer or self.mLayer

    map:AddEntity(self)
    local x, y = map:GetTileFoot(self.mTileX, self.mTileY)
    self.mX = x
    self.mY = y
end

function Entity:Render()
    love.graphics.draw(self.mSpritesheet['sheet'], self.mFrame,
        math.floor(self.mX + 0.5), math.floor(self.mY + 0.5), 0, 1, 1)
end

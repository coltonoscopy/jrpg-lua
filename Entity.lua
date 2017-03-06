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

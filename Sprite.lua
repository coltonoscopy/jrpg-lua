Sprite = {}
Sprite.__index = Sprite

function Sprite:Create()
    local this = {
        mX = 0,
        mY = 0,

        mScaleX = 1,
        mScaleY = 1,

        mTexture = nil,
        mQuad = nil
    }

    setmetatable(this, self)
    return this
end

function Sprite:SetPosition(x, y)
    self.mX = x
    self.mY = y
end

function Sprite:SetTexture(texture)
    self.mTexture = texture
end

function Sprite:SetQuad(quad)
    self.mQuad = quad
end

function Sprite:Render()
    love.graphics.draw(self.mTexture, self.mQuad,
        self.mX, self.mY, 0, self.mScaleX, self.mScaleY)
end

function Sprite:SetScale(x, y)
    self.mScaleX = x
    self.mScaleY = y
end

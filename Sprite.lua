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
    x = x + virtualWidth / 2
    y = y + virtualHeight / 2
    self.mX = x
    self.mY = y
end

function Sprite:SetTexture(texture)
    self.mTexture = texture
end

function Sprite:SetQuad(quad)
    self.mQuad = quad
end

function Sprite:GetWidth()
    if self.mQuad == nil then
        return self.mTexture:getWidth()
    else
        return self.mQuad:getWidth()
    end
end

function Sprite:GetHeight()
    if self.mQuad == nil then
        return self.mTexture:getHeight()
    else
        return self.mQuad:getHeight()
    end
end

function Sprite:Render()
    if self.mQuad == nil then
        love.graphics.draw(self.mTexture, self.mX, self.mY, 0, self.mScaleX, self.mScaleY)
    else
        love.graphics.draw(self.mTexture, self.mQuad,
            self.mX, self.mY, 0, self.mScaleX, self.mScaleY)
    end
end

function Sprite:SetScale(x, y)
    self.mScaleX = x
    self.mScaleY = y
end

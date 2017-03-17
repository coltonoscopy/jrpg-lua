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
    if self.mQuad == nil then
        x = x + virtualWidth / 2 - self.mTexture:getWidth() * self.mScaleX / 2
        y = y + virtualHeight / 2 - self.mTexture:getHeight() * self.mScaleY / 2
    else
        quadx, quady, w, h = self.mQuad:getViewport()
        x = x + virtualWidth / 2 - (w * self.mScaleX) / 2
        y = y + virtualHeight / 2 - (h * self.mScaleY) / 2
    end
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
        x, y, w, h = self.mQuad:getViewport()
        return w
    end
end

function Sprite:GetHeight()
    if self.mQuad == nil then
        return self.mTexture:getHeight()
    else
        x, y, w, h = self.mQuad:getViewport()
        return h
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

function Sprite:GetPosition()
    return Vector:Create(self.mX, self.mY)
end

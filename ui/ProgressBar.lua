ProgressBar = {}
ProgressBar.__index = ProgressBar

function ProgressBar:Create(params)
    params = params or {}

    local this = {
        mX          = params.x or 0,
        mY          = params.y or 0,
        mBackground = Sprite:Create(),
        mForeground = Sprite:Create(),
        mValue      = params.value or 0,
        mMaximum    = params.maximum or 1,
    }

    this.mBackground:SetTexture(params.background)
    this.mForeground:SetTexture(params.foreground)

    -- Get UV positions in texture atlas
    -- A table with name fields: left, top, right, bottom
    this.mHalfWidth = params.foreground:getWidth() / 2

    setmetatable(this, self)
    this:SetValue(this.mValue)
    return this
end

function ProgressBar:SetValue(value, max)
    self.mMaximum = max or self.mMaximum
    self:SetNormalValue(value / self.mMaximum)
end

function ProgressBar:SetNormalValue(value)
    self.mForeground:SetQuad(love.graphics.newQuad(0, 0,
        value * self.mBackground:GetWidth(), self.mForeground:GetHeight(),
        self.mForeground.mTexture:getDimensions()))

    self.mForeground:SetPosition(self.mX - self.mBackground:GetWidth() / 2,
        self.mY)
    self.mBackground:SetPosition(self.mX - self.mBackground:GetWidth() / 2,
        self.mY)
end

function ProgressBar:SetPosition(x, y)
    self.mX = x
    self.mY = y
    self.mBackground:SetPosition(self.mX, self.mY)
    self.mForeground:SetPosition(self.mX, self.mY)

    -- Make sure the foreground position is set correctly
    self:SetValue(self.mValue)
end

function ProgressBar:GetPosition()
    return self.mX, self.mY
end

function ProgressBar:Render()
    self.mBackground:Render()
    self.mForeground:Render()
end

require 'Tween'

Textbox = {}
Textbox.__index = Textbox

function Textbox:Create(params)
    params = params or {}

    local this = {
        mText = params.text,
        mTextScale = params.textScale or 1,
        mPanel = Panel:Create(params.panelArgs),
        mSize = params.size,
        mBounds = params.textbounds,
        mAppearTween = Tween:Create(0, 1, 0.4, Tween.EaseOutCirc),
        mWrap = params.wrap or -1
    }

    -- Calculate center point from mSize
    -- We can use this to scale.
    this.mX = (this.mSize.right + this.mSize.left) / 2
    this.mY = (this.mSize.top + this.mSize.bottom) / 2
    this.mWidth = this.mSize.right - this.mSize.left
    this.mHeight = math.abs(this.mSize.bottom - this.mSize.top)

    setmetatable(this, self)
    return this
end

function Textbox:Update(dt)
    self.mAppearTween:Update(dt)
end

function Textbox:OnClick()
    if self:IsClosed() then
        self.mAppearTween = Tween:Create(0, 1, 0.4, Tween.EaseOutCirc)
    elseif self:IsOpen() then
        self.mAppearTween = Tween:Create(1, 0, 0.2, Tween.EaseInCirc)
    end
end

function Textbox:IsOpen()
    return self.mAppearTween:IsFinished()
        and self.mAppearTween:Value() == 1
end

function Textbox:IsClosed()
    return self.mAppearTween:IsFinished()
        and self.mAppearTween:Value() == 0
end

function Textbox:Render()
    local scale = self.mAppearTween:Value()

    -- Draw the scale panel
    self.mPanel:CenterPosition(
        self.mX,
        self.mY,
        self.mWidth * scale,
        self.mHeight * scale)

    self.mPanel:Render()

    local screenCenterX = virtualWidth / 2
    local screenCenterY = virtualHeight / 2

    local left = self.mX + (virtualWidth / 2 - self.mWidth / 2 * scale)
    local textLeft = left + (self.mBounds.left) * scale
    local top = self.mY + (virtualHeight / 2 - self.mHeight / 2 * scale)
    local textTop = top - (self.mBounds.top * scale)

    -- avoid division by 0
    if scale ~= 0 then
        love.graphics.printf(self.mText, textLeft, textTop,
            (self.mWrap / (self.mTextScale * scale)) * scale, 'left', 0, self.mTextScale * scale, self.mTextScale * scale)
    end
end

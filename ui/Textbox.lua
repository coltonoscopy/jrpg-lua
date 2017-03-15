require 'Tween'

Textbox = {}
Textbox.__index = Textbox

function Textbox:Create(params)
    params = params or {}

    if type(params.text) == 'string' then
        params.text = {params.text}
    end

    local this = {
        mChunks = params.text,
        mChunkIndex = 1,
        mContinueMark = Sprite:Create(),
        mTime = 0,
        mTextScale = params.textScale or 1,
        mPanel = Panel:Create(params.panelArgs),
        mSize = params.size,
        mBounds = params.textbounds,
        mAppearTween = Tween:Create(0, 1, 0.4, Tween.EaseOutCirc),
        mWrap = params.wrap or -1,
        mChildren = params.children or {}
    }
    this.mContinueMark:SetTexture(love.graphics.newImage('graphics/continue_caret.png'))

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
    self.mTime = self.mTime + dt
    self.mAppearTween:Update(dt)
end

function Textbox:OnClick()
    if self.mChunkIndex >= #self.mChunks then
        if not (self.mAppearTween:IsFinished()
            and self.mAppearTween:Value() == 1) then
                return
        end
        self.mAppearTween = Tween:Create(1, 0, 0.2, Tween.EaseInCirc)
    else
        self.mChunkIndex = self.mChunkIndex + 1
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

    local left = self.mX + (screenCenterX - self.mWidth / 2 * scale)
    local textLeft = left + (self.mBounds.left) * scale
    local top = self.mY + (screenCenterY - self.mHeight / 2 * scale)
    local textTop = top - (self.mBounds.top * scale)
    local bottom = self.mY + (self.mHeight / 2 * scale)

    -- avoid division by 0
    if scale ~= 0 then
        love.graphics.printf(self.mChunks[self.mChunkIndex], textLeft, textTop,
            (self.mWrap / (self.mTextScale * scale)) * scale, 'left', 0, self.mTextScale * scale, self.mTextScale * scale)

        if self.mChunkIndex < #self.mChunks then
            -- There are more chunks to come
            local offset = 14 + math.floor(math.sin(self.mTime * 10)) * scale
            self.mContinueMark:SetScale(scale, scale)
            self.mContinueMark:SetPosition(self.mX, bottom - offset)
            self.mContinueMark:Render()
        end

        for k, v in ipairs(self.mChildren) do
            if v.type == 'text' then
                love.graphics.printf(v.text,
                    textLeft + (v.x * scale),
                    textTop + (v.y * scale),
                    (self.mWrap / (self.mTextScale * scale)) * scale,
                    'left', 0, self.mTextScale * scale, self.mTextScale * scale)
            elseif v.type == 'sprite' then
                local spriteLeft = self.mX - (self.mWidth / 2 * scale)
                local spriteTop = self.mY - (self.mHeight / 2 * scale)
                v.sprite:SetPosition(
                    spriteLeft + (v.x * scale) - v.sprite:GetWidth()/2 * scale,
                    spriteTop + (v.y * scale) - v.sprite:GetHeight()/2 * scale)
                v.sprite:SetScale(scale, scale)
                v.sprite:Render()
            end
        end
    end
end

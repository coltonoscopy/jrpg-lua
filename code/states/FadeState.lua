FadeState = {}
FadeState.__index = FadeState

function FadeState:Create(stack, params)
    params = params or {}
    local this = {
        mStack = stack,
        mAlphaStart = params.start or 1,
        mAlphaFinish = params.finish or 0,
        mDuration = params.time or 1
    }
    this.mColor = params.color or Vector:Create(0, 0, 0, this.mAlphaStart)
    this.mTween = Tween:Create(this.mAlphaStart,
                               this.mAlphaFinish,
                               this.mDuration)

    setmetatable(this, self)
    return this
end

function FadeState:Enter() end
function FadeState:Exit() end
function FadeState:HandleInput() end

function FadeState:Update(dt)
    self.mTween:Update(dt)

    local alpha = self.mTween:Value()
    self.mColor:SetW(alpha)

    if self.mTween:IsFinished() then
        self.mStack:Pop()
    end

    return true
end

function FadeState:Render()
    love.graphics.setColor(self.mColor:X(), self.mColor:Y(),
        self.mColor:Z(), self.mColor:W() * 255)
    love.graphics.rectangle('fill', 0, 0, virtualWidth, virtualHeight)
    love.graphics.setColor(255, 255, 255, 255)
end

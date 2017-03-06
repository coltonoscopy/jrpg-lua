WaitState = { mName = 'wait' }
WaitState.__index = WaitState

function WaitState:Create(character, map)
    local this = {
        mCharacter = character,
        mMap = map,
        mEntity = character.mEntity,
        mController = character.mController,
        mFrameResetSpeed = 0.05,
        mFrameCount = 0
    }

    setmetatable(this, self)
    return this
end

function WaitState:Enter(data)
    self.mFrameCount = 0
end

function WaitState:Render() end
function WaitState:Exit() end

function WaitState:Update(dt)
    if self.mFrameCount ~= -1 then
        self.mFrameCount = self.mFrameCount + dt
        if self.mFrameCount >= self.mFrameResetSpeed then
            self.mFrameCount = -1
            self.mEntity:SetFrame(self.mEntity.mStartFrame)
            self.mCharacter.mFacing = 'down'
        end
    end

    if love.keyboard.isDown('a') then
        self.mController:Change('move', {x = -1, y = 0})
    elseif love.keyboard.isDown('d') then
        self.mController:Change('move', {x = 1, y = 0})
    elseif love.keyboard.isDown('w') then
        self.mController:Change('move', {x = 0, y = -1})
    elseif love.keyboard.isDown('s') then
        self.mController:Change('move', {x = 0, y = 1})
    end
end

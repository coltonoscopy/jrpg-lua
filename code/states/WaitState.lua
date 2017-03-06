WaitState = { mName = 'wait' }
WaitState.__index = WaitState

function WaitState:Create(character, map)
    local this = {
        mCharacter = character,
        mMap = map,
        mEntity = character.mEntity,
        mController = character.mController
    }

    setmetatable(this, self)
    return this
end

function WaitState:Enter(data)
    self.mEntity:SetFrame(self.mEntity.mStartFrame)
end

function WaitState:Render() end
function WaitState:Exit() end

function WaitState:Update(dt)
    if love.keyboard.isDown('a') then
        print('move left requested!')
        self.mController:Change('move', {x = -1, y = 0})
    elseif love.keyboard.isDown('d') then
        self.mController:Change('move', {x = 1, y = 0})
    elseif love.keyboard.isDown('w') then
        self.mController:Change('move', {x = 0, y = -1})
    elseif love.keyboard.isDown('s') then
        self.mController:Change('move', {x = 0, y = 1})
    end
end

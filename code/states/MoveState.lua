require('Tween')

MoveState = { mName = 'move' }
MoveState.__index = MoveState

function MoveState:Create(character, map)
    local this = {
        mCharacter = character,
        mMap = map,
        mTileWidth = map.mTileWidth,
        mEntity = character.mEntity,
        mController = character.mController,
        mMoveX = 0,
        mMoveY = 0,
        mTween = Tween:Create(0, 0, 1),
        mMoveSpeed = 0.3
    }

    setmetatable(this, self)
    return this
end

function MoveState:Enter(data)
    print('move state entered!')
    self.mMoveX = data.x
    self.mMoveY = data.y
    self.mPixelX = self.mEntity.mX
    self.mPixelY = self.mEntity.mY
    self.mTween = Tween:Create(0, self.mTileWidth, self.mMoveSpeed)
end

function MoveState:Exit()
    self.mEntity.mTileX = self.mEntity.mTileX + self.mMoveX
    self.mEntity.mTileY = self.mEntity.mTileY + self.mMoveY
    Teleport(self.mEntity, self.mMap)
    print('move state exited!')
end

function MoveState:Render() end

function MoveState:Update(dt)
    self.mTween:Update(dt)

    local value = self.mTween:Value()
    local x = self.mPixelX + (value * self.mMoveX)
    local y = self.mPixelY + (value * self.mMoveY)
    self.mEntity.mX = x
    self.mEntity.mY = y

    if self.mTween:IsFinished() then
        self.mController:Change('wait')
    end
end

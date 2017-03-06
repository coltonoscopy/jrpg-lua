require('Animation')
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
    this.mAnim = Animation:Create({this.mEntity.mStartFrame})

    setmetatable(this, self)
    return this
end

function MoveState:Enter(data)
    local frames = nil

    if data.x == -1 then
        frames = self.mCharacter.mAnims.left
        self.mCharacter.mFacing = 'left'
    elseif data.x == 1 then
        frames = self.mCharacter.mAnims.right
        self.mCharacter.mFacing = 'right'
    elseif data.y == -1 then
        frames = self.mCharacter.mAnims.up
        self.mCharacter.mFacing = 'up'
    elseif data.y == 1 then
        frames = self.mCharacter.mAnims.down
        self.mCharacter.mFacing = 'down'
    end

    self.mAnim:SetFrames(frames)
    self.mMoveX = data.x
    self.mMoveY = data.y
    local pixelX = self.mEntity.mX
    local pixelY = self.mEntity.mY
    self.mPixelX = self.mEntity.mX
    self.mPixelY = self.mEntity.mY
    self.mTween = Tween:Create(0, self.mTileWidth, self.mMoveSpeed)

    local targetX = self.mEntity.mTileX + data.x
    local targetY = self.mEntity.mTileY + data.y

    if self.mMap:IsBlocked(1, targetX, targetY) then
        self.mMoveX = 0
        self.mMoveY = 0
        self.mEntity:SetFrame(self.mAnim:Frame())
        self.mController:Change(self.mCharacter.mDefaultState)
    end

    if self.mMoveX ~= 0 or self.mMoveY ~= 0 then
        local trigger = self.mMap:GetTrigger(self.mEntity.mLayer,
                                             self.mEntity.mTileX,
                                             self.mEntity.mTileY)
        if trigger then
            trigger:OnExit(self.mEntity)
        end
    end

    self.mEntity:SetTilePos(self.mEntity.mTileX + self.mMoveX,
                            self.mEntity.mTileY + self.mMoveY,
                            self.mEntity.mLayer,
                            self.mMap)
    self.mEntity.mX = pixelX
    self.mEntity.mY = pixelY
end

function MoveState:Exit()
    local trigger = self.mMap:GetTrigger(self.mEntity.mLayer,
                                         self.mEntity.mTileX,
                                         self.mEntity.mTileY)

    if trigger then
        trigger:OnEnter(self.mEntity, x, y, layer)
    end
end

function MoveState:Render() end

function MoveState:Update(dt)
    self.mAnim:Update(dt)
    self.mEntity:SetFrame(self.mAnim:Frame())
    self.mTween:Update(dt)

    local value = self.mTween:Value()
    local x = self.mPixelX + (value * self.mMoveX)
    local y = self.mPixelY + (value * self.mMoveY)
    self.mEntity.mX = x
    self.mEntity.mY = y

    if self.mTween:IsFinished() then
        self.mController:Change(self.mCharacter.mDefaultState)
    end
end

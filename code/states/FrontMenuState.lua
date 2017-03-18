FrontMenuState = {}
FrontMenuState.__index = FrontMenuState

function FrontMenuState:Create(parent, world)
    local layout = Layout:Create()
    layout:Contract('screen', 118, 40)
    layout:SplitHorz('screen', 'top', 'bottom', 0.12, 2)
    layout:SplitVert('bottom', 'left', 'party', 0.726, 2)
    layout:SplitHorz('left', 'menu', 'gold', 0.7, 2)

    local this
    this = {
        mParent = parent,
        mStack = parent.mStack,
        mStateMachine = parent.mStateMachine,
        mLayout = layout,

        mSelections = Selection:Create {
            spacingY = 32,
            data = {
                'Items',
            },
            OnSelection = function(...) this:OnMenuClick(...) end
        },

        mPanels = {
            layout:CreatePanel('gold'),
            layout:CreatePanel('top'),
            layout:CreatePanel('party'),
            layout:CreatePanel('menu')
        },
        mTopBarText = 'Current Map Name'
    }

    setmetatable(this, self)
    return this
end

function FrontMenuState:Update(dt)
    self.mSelections:HandleInput()

    if love.keyboard.wasPressed('backspace') or
        love.keyboard.wasPressed('escape') then
        self.mStack:Pop()
    end
end

function FrontMenuState:Render()
    for k, v in ipairs(self.mPanels) do
        v:Render()
    end

    local menuX = self.mLayout:Left('menu') - 16
    local menuY = self.mLayout:Top('menu') + 12
    self.mSelections:SetPosition(menuX, menuY)
    self.mSelections:Render()

    local nameX = self.mLayout:Left('top')
    local nameY = self.mLayout:MidY('top')
    love.graphics.printf(self.mTopBarText, math.floor(nameX + virtualWidth / 2),
        math.floor(nameY - 4 + virtualHeight / 2), virtualWidth + nameX, 'center', 0, 1, 1)

    local goldX = math.floor(virtualWidth/2 + self.mLayout:MidX('gold') - 20)
    local goldY = math.floor(self.mLayout:MidY('gold') - 14 + virtualHeight / 2)

    love.graphics.printf('GP:', goldX, goldY, 20, 'right', 0, 1, 1)
    love.graphics.printf('TIME:', goldX, goldY + 20, 20, 'right', 0, 1, 1)

    love.graphics.printf('0', goldX + 30, goldY, 50, 'left', 0, 1, 1)
    love.graphics.printf('0', goldX + 30, goldY + 20, 50, 'left', 0, 1, 1)
end

function FrontMenuState:OnMenuClick(index)
    local ITEMS = 1

    if index == ITEMS then
        return self.mStateMachine:Change('items')
    end
end

function FrontMenuState:Enter() end
function FrontMenuState:Exit() end

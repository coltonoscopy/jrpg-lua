Selection = {}
Selection.__index = Selection

function Selection:Create(params)
    local this = {
        mX = 0,
        mY = 0,
        mDataSource = params.data,
        mColumns = params.columns or 1,
        mFocusX = 1,
        mFocusY = 1,
        mSpacingY = params.spacingY or 24,
        mSpacingX = params.spacingX or 128,
        mCursor = Sprite:Create(),
        mShowCursor = true,
        mMaxRows = params.rows or #params.data,
        mDisplayStart = 1,
        mScale = 1,
        OnSelection = params.OnSelection or function() end
    }

    this.mDisplayRows = params.displayRows or this.mMaxRows

    local cursorTex = love.graphics.newImage(params.cursor or 'graphics/cursor.png')
    this.mCursor:SetTexture(cursorTex)
    this.mCursorWidth = cursorTex:getWidth()

    setmetatable(this, self)

    this.RenderItem = params.RenderItem or this.RenderItem
    this.mWidth = this:CalcWidth()
    this.mHeight = this:CalcHeight()

    -- Input callback function for 'just pressed' functionality
    table.insert(KEYPRESSED, function(key, code)
        if key == 'up' then
            this:MoveUp()
        elseif key == 'down' then
            this:MoveDown()
        elseif key == 'left' then
            this:MoveLeft()
        elseif key == 'right' then
            this:MoveRight()
        elseif key == 'space' then
            this:OnClick()
        end
    end)

    return this
end

function Selection:Render()
    local displayStart = self.mDisplayStart
    local displayEnd = displayStart + self.mDisplayRows - 1

    local x = self.mX
    local y = self.mY

    local cursorWidth = self.mCursorWidth * self.mScale
    local cursorHalfWidth = cursorWidth / 2
    local spacingX = (self.mSpacingX * self.mScale)
    local rowHeight = (self.mSpacingY * self.mScale)

    self.mCursor:SetScale(self.mScale, self.mScale)

    local itemIndex = ((displayStart - 1) * self.mColumns) + 1
    for i = displayStart, displayEnd do
        for j = 1, self.mColumns do
            if i == self.mFocusY and j == self.mFocusX
                and self.mShowCursor then
                    self.mCursor:SetPosition(x - cursorHalfWidth, y - self.mCursor:GetHeight() / 4)
                    self.mCursor:Render()
            end

            local item = self.mDataSource[itemIndex]
            self:RenderItem(x + cursorWidth, y, item)

            x = x + spacingX
            itemIndex = itemIndex + 1
        end

        y = y + rowHeight
        x = self.mX
    end
end

function Selection:MoveUp()
    self.mFocusY = math.max(self.mFocusY - 1, 1)
    if self.mFocusY < self.mDisplayStart then
        self:MoveDisplayUp()
    end
end

function Selection:MoveDown()
    self.mFocusY = math.min(self.mFocusY + 1, self.mMaxRows)
    if self.mFocusY >= self.mDisplayStart + self.mDisplayRows then
        self:MoveDisplayDown()
    end
end

function Selection:MoveLeft()
    self.mFocusX = math.max(self.mFocusX - 1, 1)
end

function Selection:MoveRight()
    self.mFocusX = math.min(self.mFocusX + 1, self.mColumns)
end

function Selection:OnClick()
    local index = self:GetIndex()
    self.OnSelection(index, self.mDataSource[index])
end

function Selection:MoveDisplayUp()
    self.mDisplayStart = self.mDisplayStart - 1
end

function Selection:MoveDisplayDown()
    self.mDisplayStart = self.mDisplayStart + 1
end

function Selection:GetIndex()
    return self.mFocusX + ((self.mFocusY - 1) * self.mColumns)
end

function Selection:GetWidth()
    return self.mWidth * self.mScale
end

function Selection:GetHeight()
    return self.mHeight * self.mScale
end

-- If the RenderItem function is overwritten
-- This won't give the correct result.
function Selection:CalcWidth()
    if self.mColumns == 1 then
        local maxEntryWidth = 0
        for k, v in ipairs(self.mDataSource) do
            local width = love.graphics.getFont():getWidth(tostring(v))
            maxEntryWidth = math.max(width, maxEntryWidth)
        end
        return maxEntryWidth + self.mCursorWidth
    else
        return self.mSpacingX * self.mColumns
    end
end

function Selection:CalcHeight()
    local height = self.mDisplayRows * self.mSpacingY
    return height - self.mSpacingY / 2
end

function Selection:ShowCursor()
    self.mShowCursor = true
end

function Selection:HideCursor()
    self.mShowCursor = false
end

function Selection:SetPosition(x, y)
    self.mX = x
    self.mY = y
end

function Selection:PercentageShown()
    return self.mDisplayRows / self.mMaxRows
end

function Selection:PercentageScrolled()
    local onePercent = 1 / self.mMaxRows
    local currentPercent = self.mFocusY / self.mMaxRows

    -- Allows a 0 value to be returned
    if currentPercent <= onePercent then
        currentPercent = 0
    end
    return currentPercent
end

function Selection:SelectedItem()
    return self.mDataSource[self:GetIndex()]
end

function Selection:HandleInput()

end

function Selection:RenderItem(x, y, item)
    if not item then
        love.graphics.print('--', x + virtualWidth / 2, y + virtualHeight / 2)
    else
        love.graphics.print(item, x + virtualWidth / 2, y + virtualHeight / 2)
    end
end
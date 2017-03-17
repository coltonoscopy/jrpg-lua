StateStack = {}
StateStack.__index = StateStack

function StateStack:Create()
    local this = {
        mStates = {}
    }

    setmetatable(this, self)
    return this
end

function StateStack:Update(dt)
    -- update them and check input
    for k = #self.mStates, 1, -1 do
        local v = self.mStates[k]
        local continue = v:Update(dt)
        if not continue then
            break
        end
    end

    local top = self.mStates[#self.mStates]

    if not top then
        return
    end

    top:HandleInput()
end

function StateStack:Render()
    for _, v in ipairs(self.mStates) do
        v:Render()
    end
end

function StateStack:PushFix(x, y, width, height, text, params)
    params = params or {}
    local avatar = params.avatar
    local title = params.title
    local choices = params.choices

    local padding = 10
    local textScale = 1.5
    local panelTileSize = 3

    local wrap = width - padding * 2
    local boundsTop = padding
    local boundsLeft = padding
    local boundsBottom = padding

    local children = {}

    if avatar then
        boundsLeft = avatar:getWidth() + padding * 2
        wrap = width - (boundsLeft) - padding
        local sprite = Sprite:Create()
        sprite:SetTexture(avatar)
        table.insert(children,
        {
            type = 'sprite',
            sprite = sprite,
            x = avatar:getWidth() / 2 + padding,
            y = avatar:getHeight() / 2
        })
    end

    local selectionMenu = nil
    if choices then
        -- options and callback
        selectionMenu = Selection:Create {
            data = choices.options,
            OnSelection = choices.OnSelection,
            textScale = choices.textScale
        }
        boundsBottom = boundsBottom - padding * 0.5
    end

    if title then
        -- adjust the top
        local size = love.graphics.getFont():getHeight()
        boundsTop = size + padding * 2

        table.insert(children,{
            type = 'text',
            text = title,
            x = 0,
            y = -size - padding
        })
    end

    -- Temp scaled font to get proper wrapping measurements
    local scaledFont = love.graphics.newFont('fonts/04B_03__.TTF',
        love.graphics.getFont():getHeight() * textScale)
    local faceHeight = scaledFont:getHeight()
    local textWidth, lines = scaledFont:getWrap(text, wrap)

    local boundsHeight = height - (boundsBottom + boundsTop)
    local currentHeight = faceHeight

    local lineCounter = 1
    local chunks = {{lines[lineCounter]}}
    if #lines > 1 then
        while lineCounter <= #lines do
            lineCounter = lineCounter + 1

            -- If we're going to overflow
            if (currentHeight + faceHeight) > boundsHeight then
                -- make a new entry
                currentHeight = 0
                table.insert(chunks, {lines[lineCounter]})
            else
                table.insert(chunks[#chunks], lines[lineCounter])
            end
            currentHeight = currentHeight + faceHeight
        end
    end

    -- Make each textbox be represented by one string.
    for k, v in ipairs(chunks) do
        chunks[k] = table.concat(v)
    end

    local textbox = Textbox:Create {
        text = chunks,
        textScale = textScale,
        size = {
            left = x - width / 2,
            right = x + width / 2,
            top = y - height / 2,
            bottom = y + height / 2,
        },
        textbounds = {
            left = boundsLeft,
            right = -padding,
            top = -boundsTop,
            bottom = padding
        },
        panelArgs = {
            texture = 'graphics/gradient_panel.png',
            size = panelTileSize
        },
        children = children,
        wrap = wrap,
        selectionMenu = selectionMenu,
        stack = self
    }

    table.insert(self.mStates, textbox)
end

function StateStack:PushFit(x, y, text, wrap, params)
    local params = params or {}
    local choices = params.choices
    local title = params.title
    local avatar = params.avatar

    local padding = 10
    local panelTileSize = 3
    local textScale = 1.5

    local scaledFont = love.graphics.newFont('fonts/04B_03__.TTF',
        love.graphics.getFont():getHeight() * textScale)
    local size = scaledFont:getWidth(text)
    local width = size + padding * 2
    local height = scaledFont:getHeight() + padding * 2

    if choices then
        -- options and callback
        local selectionMenu = Selection:Create {
            data = choices.options,
            displayRows = #choices.options,
            columns = 1
        }
        height = height + selectionMenu:GetHeight() + padding * 4
        width = math.max(width, selectionMenu:GetWidth() + padding * 2)
    end

    if title then
        height = height + scaledFont:getHeight() + padding
        width = math.max(width, size + padding)
    end

    if avatar then
        local avatarWidth = avatar:getWidth()
        local avatarHeight = avatar:getHeight()
        width = width + avatarWidth + padding
        height = math.max(height, avatarHeight + padding)
    end

    return self:PushFix(x, y, width, height, text, params)
end

function StateStack:Push(state)
    table.insert(self.mStates, state)
    state:Enter()
end

function StateStack:Pop()
    local top = self.mStates[#self.mStates]
    table.remove(self.mStates)
    top:Exit()
    return top
end

function StateStack:Top()
    return self.mStates[#self.mStates]
end

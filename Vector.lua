Vector = {}
Vector.__index = Vector

function Vector:Create(x, y, z)
    local this = {
        mX = x or 0,
        mY = y or 0,
        mZ = z or 0
    }

    setmetatable(this, self)
    return this
end

function Vector:X()
    return self.mX
end

function Vector:Y()
    return self.mY
end

function Vector:Z()
    return self.mZ
end

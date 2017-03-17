Vector = {}
Vector.__index = Vector

function Vector:Create(x, y, z, w)
    local this = {
        mX = x or 0,
        mY = y or 0,
        mZ = z or 0,
        mW = w or 0
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

function Vector:W()
    return self.mW
end

function Vector:SetX(x)
    self.mX = x
end

function Vector:SetY(y)
    self.mY = y
end

function Vector:SetZ(z)
    self.mZ = z
end

function Vector:SetW(w)
    self.mW = w
end

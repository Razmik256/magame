local ObjectC = {}
ObjectC.__index = ObjectC

function ObjectC.new(x,y,w,h)
    local self = setmetatable({x=x,y=y,w=w,h=h},ObjectC)
    return self
end

function ObjectC:is_hover(obj)
    if obj.x > self.x-Camera.x and obj.x < self.x+self.w-Camera.x and
    obj.y > self.y-Camera.y and obj.y < self.y+self.h-Camera.y then
        return true
    end
    return false
end

return ObjectC
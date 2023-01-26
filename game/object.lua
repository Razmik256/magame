ObjectC = {}
ObjectC.__index = ObjectC

function ObjectC.new(x,y,w,h)
    local self = setmetatable({x=x,y=y,w=w,h=h}, ObjectC)
    return self
end

-- learn the fucking collision math
function ObjectC:AABB(x2,y2,w2,h2)
    return self.x < x2+w2 and
           x2 < self.x+self.w and
           self.y < y2+h2 and
           y2 < self.y+self.h
end
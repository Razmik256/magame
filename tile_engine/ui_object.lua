local ObjectC = require("object")

local Ui_ObjC = {}
Ui_ObjC.__index = Ui_ObjC
setmetatable(Ui_ObjC, ObjectC)

function Ui_ObjC.new(x,y,w,h)
    local self = setmetatable(ObjectC.new(x,y,w,h), Ui_ObjC)
    return self
end

function Ui_ObjC:is_hover()
    if Cursor.x > self.x and Cursor.x < self.x+self.w and
    Cursor.y > self.y and Cursor.y < self.y+self.h then
        return true
    end
    return false
end

return Ui_ObjC
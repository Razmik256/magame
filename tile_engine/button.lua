local Ui_ObjC = require("ui_object")

local ButtonC = {}
ButtonC.__index = ButtonC
setmetatable(ButtonC, Ui_ObjC)

function ButtonC.new(x,y,w,h,text)
    local self = setmetatable(Ui_ObjC.new(x,y,w,h), ButtonC)
    self.text = text
    self.hover = false
    return self
end

function ButtonC:draw()
    love.graphics.setColor({.3,.3,.3,1})
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
    if self.hover == true then
        love.graphics.setColor({.5,.5,.5,1})
    else
        love.graphics.setColor({1,1,1,1})
    end
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    love.graphics.print(self.text, self.x, self.y)
end

return ButtonC
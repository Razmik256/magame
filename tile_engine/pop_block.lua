local Ui_ObjC = require("ui_object")

local Pop_BlockC = {}
Pop_BlockC.__index = Pop_BlockC
setmetatable(Pop_BlockC,Ui_ObjC)

function Pop_BlockC.new(x,y,w,h,text,is_input,data, func)
    local self = setmetatable(Ui_ObjC.new(x,y,w,h), Pop_BlockC)
    self.text = text
    self.is_input = is_input
    self.data = ""
    self.func = func
    return self
end

function Pop_BlockC:draw()
    love.graphics.setColor({.5,.5,.5,1})
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
    love.graphics.setColor({1,1,1,1})
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    love.graphics.print("press enter to exit", self.x+self.w/3-#self.text,self.y+4)
    if self.is_input then
        love.graphics.print(self.text, self.x+self.w/3-#self.text,self.y+self.h/4-4)
        love.graphics.print(self.data, self.x+self.w/3-#self.text,self.y+self.h/3-4)
    else
        love.graphics.print(self.text, self.x+self.w/3-#self.text, self.y+self.h/2-#self.text)
    end
end

return Pop_BlockC
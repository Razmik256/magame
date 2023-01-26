local AnimationC = {}
AnimationC.__index = AnimationC

-- the animation divides the spritesheet into cells, indexing each from 1
function AnimationC.new(spriteName, cw, ch, speed, sx,sy,ofx,ofy)
    local self = setmetatable({},AnimationC)
    self.sprite = love.graphics.newImage(spriteName)
    self.quads = {}
    self.widht = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.cellW = cw
    self.cellH = ch
    self.speed = speed
    self.ssx = sx -- saved scaling
    self.ssy = sy
    self.sx = sx -- x scaling
    self.sy = sy
    self.soffx = ofx -- saved scaling
    self.soffy = ofy
    self.offx = ofx -- x scaling
    self.offy = ofy
    for y = 0, self.height-self.cellH, self.cellH do
        for x = 0, self.widht-self.cellW, self.cellW do
            table.insert(self.quads,love.graphics.newQuad(x,y,self.cellW, self.cellH,self.sprite:getDimensions()))
        end
    end
    self.timer = 0
    self.drawQ = self.quads[1]
    self.index = 0
    return self
end

function AnimationC:createList(startP, endP)
    local newq = {}
    for i=startP,endP,1 do
        table.insert(newq, self.quads[i])
    end
    return newq
end

function AnimationC:scale(width, height)
    self.sx = width/self.cellW
    self.sy = height/self.cellH
    self.ssx = self.sx
    self.ssy = self.sx
end

function AnimationC:resetIndex()
    self.index = 1
end

function AnimationC:play(dt,list,speed)
    self.timer = self.timer + dt
    if self.timer >= speed then
        if self.index >= #list then
            self.index = 1
        else
            self.index = self.index + 1
        end
        self.drawQ = list[self.index]
        self.timer = 0
    end
end

return AnimationC
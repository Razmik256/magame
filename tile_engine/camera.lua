local CameraC = {}
CameraC.__index = CameraC

function CameraC.new(x,y)
    local self = setmetatable({x=x,y=y},CameraC)
    self.speed = 10
    return self
end

function CameraC:move() 
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed
 
    elseif love.keyboard.isDown("d") then
        self.x = self.x + self.speed

    end
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed

    elseif love.keyboard.isDown("s") then
        self.y = self.y + self.speed
    end
end

function CameraC:attach()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
end
function CameraC:dettach()
    love.graphics.pop()
end

return CameraC
local CameraC = {}
CameraC.__index = CameraC

function CameraC.new(x,y)

    local self = setmetatable({x=x,y=y},CameraC);
    return self

end

function CameraC:move_to(x,y)
    self.x = x
    self.y = y
end

return CameraC
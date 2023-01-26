local ObjectC = require("object")

local EnemyC = {}
EnemyC.__index = EnemyC
setmetatable(EnemyC, ObjectC)

function EnemyC.new(x,y,w,h, target)
    local self = setmetatable(ObjectC.new(x,y,w,h),EnemyC);
    self.speed = 5
    self.dx = 0
    self.dy = 0
    self.velocity_y = 0
    self.jumpStr = 15
    self.can_jump = false
    self.gravity = 1

    self.target = target

    return self
end

function EnemyC:move(dt)
    self.dx = 0
    self.dy = 0

    if self.target.x < self.x then
        self.dx = self.dx - self.speed
    elseif self.target.x > self.x then
        self.dx = self.dx + self.speed
    end
    if self.target.y < self.x and self.can_jump == true then
        self.velocity_y = -self.jumpStr
        self.can_jump = false
    end
    self.velocity_y = self.velocity_y + self.gravity
    if self.velocity_y >= 10 then
        self.velocity_y = 10
    end

    self.dy = self.dy + self.velocity_y
    for _, o in ipairs(Objects) do
        -- x
        if o:AABB(self.x+self.dx, self.y-self.dy, self.w, self.h) then
            self.dx = 0
        end
        -- y
        if o:AABB(self.x, self.y+self.dy, self.w,self.h) then
            if self.velocity_y < 0 then
                self.dy = o.y+o.h-self.y
            else
                self.dy = o.y-(self.y+self.h)
                self.can_jump = true
            end
        end
    end
    if self.dy > 0 then
        self.can_jump = false
    end

    self.x = self.x + self.dx
    self.y = self.y + self.dy
end

return EnemyC
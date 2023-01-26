require("object")
require("animation")

PlayerC = {}
PlayerC.__index = PlayerC
setmetatable(PlayerC, ObjectC)

function PlayerC.new(x,y,w,h)
    local self = setmetatable(ObjectC.new(x,y,w,h),PlayerC);
    self.anim = AnimationC.new("testSheet.png", 22,24,0.07,1,1,0,0)
    self.anim:scale(w,h)
    self.speed = 5
    self.dx = 0
    self.dy = 0
    self.velocity_y = 0
    self.jumpStr = 15
    self.can_jump = false
    self.gravity = 1

    self.anim.idle = self.anim:createList(1,3)
    self.anim.run = self.anim:createList(4,6)
    return self
end

function PlayerC:move(dt)
    self.dx = 0
    self.dy = 0
    -- player movement
    if love.keyboard.isDown("a") then
        self.dx = self.dx - self.speed
    elseif love.keyboard.isDown("d")then
        self.dx = self.dx + self.speed
    end
    if love.keyboard.isDown("w") and self.can_jump == true then
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
    
    -- animation
    if love.keyboard.isDown("a") or
    love.keyboard.isDown("d") then
        self.anim:play(dt,self.anim.run, self.anim.speed)
    else
        self.anim:play(dt,self.anim.idle, 0.5)
    end
    self.x = self.x + self.dx
    self.y = self.y + self.dy
end

return PlayerC
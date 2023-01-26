PlayerC = require("player")

function Make_Level(filename)
    local levelfile = assert(io.open(filename))
    Objects = {}
    local lines = levelfile:lines()
    local i = 0
    local tile = {}
    local gridS = tonumber(lines())
    for line in lines do
        for str in string.gmatch(line, "([^".."%s".."]+)") do
            i = i + 1
            table.insert(tile, str)
            if i == 3 then
                local obj = ObjectC.new(tonumber(tile[2]),tonumber(tile[3]),gridS,gridS)
                table.insert(Objects, obj)
                tile = {}
            end
        end
        i = 0
    end
end

function love.load()
    Player = PlayerC.new(64,64,64,64)
    Make_Level("game/level1")
end

function love.update(dt)
    Player:move(dt)
end

function love.keypressed(key)
    if key == "a" or
    key == "d" or
    key == "w" then
        Player.anim:resetIndex()
    end
    if key == "a" then 
        Player.anim.sx = -Player.anim.ssx
        Player.anim.offx = Player.anim.soffx+Player.anim.cellW
    elseif key == "d" then
        Player.anim.sx = Player.anim.ssx
        Player.anim.offx = Player.anim.soffx
    end
end

function love.keyreleased(key)
    if key == "a" or
    key == "d" then
        Player.anim:resetIndex()
        Player.anim.drawQ = Player.anim.quads[1]
    end
end

function DebugDraw(obj)
    love.graphics.circle("fill",obj.x,obj.y, 4)
    love.graphics.print(tostring(math.floor(obj.x)) .. " : " .. tostring(math.floor(obj.y)),obj.x+5, obj.y-16)
    love.graphics.rectangle("line", obj.x, obj.y, obj.w, obj.h)
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Player.anim.sprite,Player.anim.drawQ, Player.x,Player.y, 0, Player.anim.sx, Player.anim.sy,Player.anim.offx, Player.anim.offy)
    DebugDraw(Player)
    for _, o in ipairs(Objects) do
        DebugDraw(o)
    end
end

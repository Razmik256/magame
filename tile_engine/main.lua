local ObjectC    = require("object")
local CameraC    = require("camera")
local ButtonC    = require("button")
local Pop_BlockC = require("pop_block")

-- STOP OVERTHINKING
function love.load()
    -- LevelW, LevelH, GridS = io.read("*n","*n","*n")
    WindowW = 1280
    WindowH = 720
    GridS = 64
    love.window.setMode(1280,720,{resizable=true})
    Cursor = ObjectC.new(love.mouse.getX(),love.mouse.getY(),0,0)
    Camera = CameraC.new(0,0)
    
    -- tiles
    Current_Tile = ""
    Tile_Sprites = {}
    Tiles = {}
    
    -- input output
    Pop_Block = nil
    Main_State = "edit"
    -- buttons
    Buttons = {}
    Last_Button_Y = 128
    New_Tile_Button = ButtonC.new(64, 64, 128,64, "New tile")
    table.insert(Buttons,New_Tile_Button)

    Save_Button = ButtonC.new(64, 128, 128,64, "Save level")
    table.insert(Buttons,Save_Button)

    Is_ui_hover = false

    for i = 0,math.floor(WindowW/GridS), 1 do
        for j = 0, math.floor(WindowH/GridS), 1 do
            local t = ObjectC.new(64*i,64*j,64,64)
            t.value = ""
            table.insert(Tiles,t)
        end
    end
end

function love.mousepressed(x,y,button)
    for _,b in ipairs(Buttons) do
        if b:is_hover() and button == 1 then
            if b == New_Tile_Button then
                local func = function ()
                    if love.filesystem.getInfo('tile_sprites/'..Pop_Block.data) ~= nil then
                        Last_Button_Y = Last_Button_Y + 64
                        table.insert(Buttons, ButtonC.new(64,Last_Button_Y,128,64,Pop_Block.data))
                        Tile_Sprites[Pop_Block.data] = love.graphics.newImage('tile_sprites/'..Pop_Block.data)
                        return true
                    else
                        Pop_Block.text = "File ".. Pop_Block.data .. " does not exist"
                        return false
                    end
                end
                Pop_Block = Pop_BlockC.new(WindowW/2-256,WindowH/2-128,256,128, "Tile sprite name", true, "", func)
                Pop_Block.state = "inputing"
                Main_State = "get_input"
            elseif b == Save_Button then
                local func = function ()
                    local file = assert(io.open('tile_engine/save_files/' .. Pop_Block.data, 'w+'))
                    file:write(GridS .. "\n")
                    for _, t in ipairs(Tiles) do
                        if t.value ~= "" then
                            local v = string.gsub(t.value, ".png", "")
                            file:write(v .. " " .. t.x .. " " .. t.y .. "\n")
                        end
                    end
                    file:close()
                    return true
                end
                Pop_Block = Pop_BlockC.new(WindowW/2-256,WindowH/2-128,256,128, "Type level name", true, "", func)
                Pop_Block.state = "inputing"
                Main_State = "get_input"
            else
                Current_Tile = b.text
            end
        end
    end
end

function love.textinput(key)
    if Main_State == "get_input" then
        if #Pop_Block.data < 16 then
            Pop_Block.data = Pop_Block.data .. key
        end
    end
end

function love.keypressed(key)
    if Main_State == "get_input" then
        if key == "backspace" then
            Pop_Block.data = string.sub(Pop_Block.data, 1,#Pop_Block.data-1)
        elseif key == "return" then
            if Pop_Block:func() then
                Main_State = "edit"
            end
        elseif key == "escape" then
            Main_State = "edit"
            Pop_Block = nil
        end
    end
end

function love.update(dt)
    Cursor.x, Cursor.y = love.mouse.getX(), love.mouse.getY()
    if Main_State == "edit" then

        Camera:move()

        for _, t in ipairs(Tiles) do
            if t:is_hover(Cursor) and Is_ui_hover == false then
                if love.mouse.isDown(1) then
                    t.value = Current_Tile
                elseif love.mouse.isDown(2) then
                    t.value = ""
                end
            end
        end
    -- elseif Main_State == "show_pop_up" then
    end
end

function love.draw()
    
    Camera:attach()
    for i=0, WindowW/(GridS), 5 do
        for j=0, WindowH/(GridS), 5 do
            love.graphics.setColor({1,0,0,1})
            love.graphics.circle("fill",i*GridS,j*GridS,10)
        end
    end
    for _, t in ipairs(Tiles) do
            love.graphics.setColor({1,1,1,1})
            if Tile_Sprites[t.value] ~= nil then
                love.graphics.draw(Tile_Sprites[t.value], t.x,t.y)
            else
                love.graphics.rectangle("line",t.x,t.y,t.w,t.h)
            end
            -- love.graphics.print(t.value, t.x,t.y)
    end
    Camera:dettach()

    -- upper layer ui
    Is_ui_hover = false
    for _, b in ipairs(Buttons) do
        if b:is_hover() then
            b.hover = true
            Is_ui_hover = true
        else
            b.hover = false
        end
        b:draw()
    end
    
    love.graphics.setColor({1,1,1,1})
    love.graphics.print(WindowW..":"..WindowH.."/"..GridS, 0,0)
    
    if Main_State == "get_input" then
        Pop_Block:draw()
    end

    -- Cursor
    love.graphics.circle("line",Cursor.x,Cursor.y,5)

end
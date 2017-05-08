screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

block_body_size = 20
body_speed_default = 100
body_speed_default_stop = 0

linetable = {10,10,10,screenHeight-10,screenWidth-10,screenHeight-10,screenWidth-10,10,10,10}

function love.load ()
  love.graphics.setBackgroundColor(255,255,255)
  love.graphics.setColor(0,0, 0)

  player = { x = screenWidth/2 , y = screenHeight/2,size_body = 0 ,speed_x = body_speed_default,speed_y = body_speed_default_stop,}
  body = {}

  -- table.insert(player,body)

  add_block()
  add_block()

end


function add_block()
    new_block = {x = player.x + block_body_size, y = player.y + block_body_size}
    table.insert(body,new_block)
    player.size_body = player.size_body + 1
    print("Criei Corpo no Player! : ")
    print(player.size_body)
end

function love.keypressed (key)
    if key == 'left' then
        player.speed_x = -body_speed_default
        player.speed_y = body_speed_default_stop
    elseif key == 'right' then
        player.speed_x = body_speed_default
        player.speed_y = body_speed_default_stop
    elseif key == 'up' then
        player.speed_x = body_speed_default_stop
        player.speed_y = -body_speed_default
    elseif key == 'down' then
        player.speed_y = body_speed_default
        player.speed_x = body_speed_default_stop
    end
end

--[[
function collides (o1, o2)
    return (o1.x+o1.w >= o2.x) and (o1.x <= o2.x+o2.w) and
           (o1.y+o1.h >= o2.y) and (o1.y <= o2.y+o2.h)
end
  --]]

function love.update (dt)
  player.x =  player.x + player.speed_x * dt
  player.y =  player.y + player.speed_y * dt
end


function love.draw()
  -- quad start
   love.graphics.line(linetable)

   love.graphics.rectangle( "fill", player.x, player.y, block_body_size, block_body_size )

   for i,block in ipairs(body) do
     love.graphics.rectangle( "fill", body[i].x, body[i].y, block_body_size, block_body_size )
   end
end

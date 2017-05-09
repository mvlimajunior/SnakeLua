screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

default_block_size = 20

player_movement_speed = 100
player_no_speed = 0

function love.load ()

  -- Inicializa a Cor do Cenário
  love.graphics.setBackgroundColor(255,255,255)

  -- Inicializa a Cor das Linhas de Demarcação do Cenário.
  love.graphics.setColor(0,0, 0)

  scenarioLimits = {10,10,10,screenHeight-10,screenWidth-10,screenHeight-10,screenWidth-10,10,10,10}

  -- Iniciliza o Jogador.
  player = {
    x = screenWidth/2,
    y = screenHeight/2,
    speed_x = player_movement_speed,
    speed_y = player_no_speed,
    body_size = 0,
    body = {}
  }

  food = {
    x = nil,
    y = nil,
    isAlive = true
  }

  -- Inicializa dois blocos ao Jogador e Inicializa comida no cenário.
  playerAddBlock()
  playerAddBlock()
  respawnPlayerFood()

end

-- Aumenta o comprimento do Jogador.
function playerAddBlock()

  if (player.body_size == 0) then
    new_block = {
      x = player.x,
      y = player.y + default_block_size
    }
  else
    new_block = {
      x = player.x,
      y = player.y + ( default_block_size * (player.body_size + 1))
    }

  end

  table.insert(player.body,new_block)

  player.body_size = player.body_size + 1

  print("Criei Corpo no Player! : ")
  print(player.body_size)
end

function respawnPlayerFood()

  food.x = love.math.random(10, screenWidth - 10)
  food.y = love.math.random(10, screenHeight - 10)
  food.isAlive = true

end

function love.keypressed (key)
    if key == 'left' then
        player.speed_x = -player_movement_speed
        player.speed_y = player_no_speed
    elseif key == 'right' then
        player.speed_x = player_movement_speed
        player.speed_y = player_no_speed
    elseif key == 'up' then
        player.speed_x = player_no_speed
        player.speed_y = -player_movement_speed
    elseif key == 'down' then
        player.speed_y = player_movement_speed
        player.speed_x = player_no_speed
    end
end

--[[
function collides (o1, o2)
    return (o1.x+o1.w >= o2.x) and (o1.x <= o2.x+o2.w) and
           (o1.y+o1.h >= o2.y) and (o1.y <= o2.y+o2.h)
end
  --]]

function love.update (dt)
  --player.x =  player.x + player.speed_x * dt
  --player.y =  player.y + player.speed_y * dt
end

function drawPlayer()

  love.graphics.setColor(255, 0, 0, 180)

  -- Desenho do Jogador. ( Cabeça )
  love.graphics.rectangle( "fill", player.x, player.y, default_block_size, default_block_size )

  love.graphics.setColor(0, 0, 0, 255)
  -- Desenho do Corpo.
 for i,block in ipairs(player.body) do
   love.graphics.rectangle( "fill", block.x, block.y, default_block_size, default_block_size )
 end

end

function love.draw()

  -- Desenho do Cenário.
  love.graphics.line(scenarioLimits)

  -- Desenha o Jogador.
  drawPlayer()

  -- Desenho da Comida.
  if (food.isAlive) then
    love.graphics.setColor(0,0,255)
    love.graphics.rectangle( "fill", food.x, food.y, default_block_size, default_block_size )
  end

end

screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

default_block_size = 20

player_movement_speed = 100
player_no_speed = 0
player_body_gap = 1

function love.load ()

  -- Inicializa a Cor do Cenário
  love.graphics.setBackgroundColor(255,255,255)

  -- Inicializa a Cor das Linhas de Demarcação do Cenário.
  love.graphics.setColor(0,0, 0)

  -- Define os limites do cenário na tela.
  scenarioLimits = {10,10,10,screenHeight-10,screenWidth-10,screenHeight-10,screenWidth-10,10,10,10}

  -- Iniciliza o Jogador.
  player = {
    x = screenWidth/2,
    y = screenHeight/2,
    speed_x = player_no_speed,
    speed_y = player_movement_speed,
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
      y = player.y + default_block_size + player_body_gap
    }
  else
    new_block = {
      x = player.x,
      y = player.y + ( ( default_block_size + player_body_gap ) * (player.body_size + 1) )
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

-- Jogador colidindo com as paredes.
function playerWallCollision (player, wall)
  return true
end

-- Jogador colidindo com a comida.
function playerFoodCollision (player, food)
  if ( player.x + default_block_size >= food.x ) and ( player.x <= food.x + default_block_size) and ( player.y + default_block_size >= food.y) and ( player.y <= food.y + default_block_size ) then
    playerAddBlock()
    respawnPlayerFood()
  end
end

-- Jogador colidindo com ele mesmo.
function playerBodyCollision (player)
  return true
end

function love.update (dt)
  player.x =  player.x + player.speed_x * dt
  player.y =  player.y + player.speed_y * dt

  for i,block in ipairs(player.body) do

    block.x = block.x + player.speed_x * dt
    block.y = block.y + player.speed_y * dt

  end

  playerFoodCollision(player,food)

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

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

  -- Define os limites do cenário na tela. ( Xi , Yi )
  scenarioLimits = {
    10,10,
    10,screenHeight-10,
    screenWidth-10,screenHeight-10,
    screenWidth-10,10,
    10,10
  }

  -- Iniciliza o Jogador.
  player = {
    pos = {
      x = screenWidth/2,
      y = screenHeight/2,
    },
    speed = {
      x = player_no_speed,
      y = -player_movement_speed,
    },
    body = {
      size = 0,
      blocks = {}
    }
  }

  food = {
    pos = {
      x = nil,
      y = nil
    },
    isAlive = false
  }

  -- Inicializa dois blocos ao Jogador e Inicializa comida no cenário.
  playerAddBlock()
  playerAddBlock()
  respawnPlayerFood()

end

-- Aumenta o comprimento do Jogador.
function playerAddBlock()

  if (player.body.size == 0) then
    new_block = {
      pos = {
        x = player.pos.x,
        y = player.pos.y + default_block_size + player_body_gap
      },
      speed = {
        x = player.speed.x,
        y = player.speed.y,
      }
    }
  else
    new_block = {
      pos = {
        x = player.pos.x,
        y = player.pos.y + ( ( default_block_size + player_body_gap ) * (player.body.size + 1) )
      },
      speed = {
        x = player.speed.x,
        y = player.speed.y,
      }
    }

  end

  table.insert(player.body.blocks,new_block)

  player.body.size = player.body.size + 1

  print("Criei Corpo no Player! : ")
  print(player.body.size)
end

function respawnPlayerFood()

  food.pos.x = love.math.random(10, screenWidth - 10)
  food.pos.y = love.math.random(10, screenHeight - 10)
  food.isAlive = true

end

function gameOver()
 return true
end

function love.keypressed (key)
    if key == 'left' then
        player.speed.x = -player_movement_speed
        player.speed.y = player_no_speed
    elseif key == 'right' then
        player.speed.x = player_movement_speed
        player.speed.y = player_no_speed
    elseif key == 'up' then
        player.speed.x = player_no_speed
        player.speed.y = -player_movement_speed
    elseif key == 'down' then
        player.speed.y = player_movement_speed
        player.speed.x = player_no_speed
    end
end

-- Jogador colidindo com as paredes.
function playerWallCollision (player, wall)

end

-- Jogador colidindo com a comida.
function playerFoodCollision (player, food)
  if ( player.pos.x + default_block_size >= food.pos.x ) and ( player.pos.x <= food.pos.x + default_block_size) and ( player.pos.y + default_block_size >= food.pos.y) and ( player.pos.y <= food.pos.y + default_block_size ) then
    playerAddBlock()
    respawnPlayerFood()
  end
end

-- Jogador colidindo com ele mesmo.
function playerBodyCollision (player)
  return true
end

function love.update (dt)
  player.pos.x =  player.pos.x + player.speed.x * dt
  player.pos.y =  player.pos.y + player.speed.y * dt

  for i,block in ipairs(player.body.blocks) do

    --[[if (i <= 1) then
      if (block.pos.x < player.pos.x) then
        block.speed.y = player.speed.x
        block.speed.x = player.speed.y
      end
    else
      if (block.pos.x < player.body.blocks[i-1].pos.x) then
        block.speed.y = player.body.blocks[i-1].speed.x
        block.speed.x = player.body.blocks[i-1].speed.y
      end
    end--]]

    block.pos.x = block.pos.x + block.speed.x * dt
    block.pos.y = block.pos.y + block.speed.y * dt
  end

  playerFoodCollision(player,food)

end

function drawPlayer()

  love.graphics.setColor(255, 0, 0, 180)

  -- Desenho do Jogador. ( Cabeça )
  love.graphics.rectangle( "fill", player.pos.x, player.pos.y, default_block_size, default_block_size )

  love.graphics.setColor(0, 0, 0, 255)
  -- Desenho do Corpo.
 for i,block in ipairs(player.body.blocks) do
   love.graphics.rectangle( "fill", block.pos.x, block.pos.y, default_block_size, default_block_size )
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
    love.graphics.rectangle( "fill", food.pos.x, food.pos.y, default_block_size, default_block_size )
  end

end

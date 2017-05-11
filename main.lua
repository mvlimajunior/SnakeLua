screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

default_block_size = 20

player_movement_speed = 50
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
      last_x = nil,
      last_y = nil,
    },
    direction = {
      x = 0,
      y = -1,
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
  respawnPlayerFood()

end

-- Aumenta o comprimento do Jogador.
function playerAddBlock(n)

  if (n == nil or n > 0) then

    if (player.body.size == 0) then
      new_block = {
        pos = {
          x = player.pos.x + ( default_block_size * player.direction.x ) + player_body_gap,
          y = player.pos.y + ( default_block_size * player.direction.y ) + player_body_gap,
          last_x = nil,
          last_y = nil
        },
        direction = {
          x = player.direction.x,
          y = player.direction.y
        }
      }
    else
      new_block = {
        pos = {
          x = player.pos.x + ( ( default_block_size * player.direction.x) * (player.body.size + 1) ) + player_body_gap,
          y = player.pos.y + ( ( default_block_size * player.direction.y) * (player.body.size + 1) ) + player_body_gap,
          last_x = nil,
          last_y = nil
        },
        direction = {
          x = player.direction.x,
          y = player.direction.y
        }
      }

    end

    table.insert(player.body.blocks,1,new_block)

    player.body.size = player.body.size + 1

    print("Criei Corpo no Player! : ")
    print(player.body.size)

  end

  if (n ~= nil and n > 0) then
    playerAddBlock(n-1)
  end

end

function respawnPlayerFood()

  food.pos.x = love.math.random(10, screenWidth - 20)
  food.pos.y = love.math.random(10, screenHeight - 20)
  food.isAlive = true

end

function gameOver()
 return true
end

function love.keypressed (key)
    if key == 'left' or key == 'd' then
        player.direction.x = -1
        player.direction.y = 0
    elseif key == 'right' then
        player.direction.x = 1
        player.direction.y = 0
    elseif key == 'up' then
        player.direction.x = 0
        player.direction.y = -1
    elseif key == 'down' then
        player.direction.y = 1
        player.direction.x = 0
    elseif key == 'f' then
        playerAddBlock()
    elseif key == '2' then
        player_movement_speed = player_movement_speed + 50
      elseif key == '1' then
          player_movement_speed = player_movement_speed - 50
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

  player.pos.last_x = player.pos.x
  player.pos.last_y = player.pos.y

  player.pos.x =  player.pos.x + player.direction.x * player_movement_speed * dt
  player.pos.y =  player.pos.y + player.direction.y * player_movement_speed * dt

  for i,block in ipairs(player.body.blocks) do

    block.pos.last_x = block.pos.x
    block.pos.last_y = block.pos.y

    if (i <= 1) then
      block.pos.x = player.pos.last_x - default_block_size * player.direction.x
      block.pos.y = player.pos.last_y - default_block_size * player.direction.y
    else
      block.pos.x = player.body.blocks[i-1].pos.last_x - default_block_size * player.direction.x
      block.pos.y = player.body.blocks[i-1].pos.last_y - default_block_size * player.direction.y
    end
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

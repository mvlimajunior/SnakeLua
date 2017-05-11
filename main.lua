screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

default_block_size = 20

player_movement_speed = 100
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
      current = {
        x = screenWidth/2,
        y = screenHeight/2
      },
      previous = {
        x = nil,
        y = nil
      }
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

  accumulator = { current = 0; limit= 0.27; }

end

-- Aumenta o comprimento do Jogador.
function playerAddBlock(n)

  if (n == nil) then
    n = 1
  end

  -- Estrutura do Novo Bloco.
  new_block = {
    pos = {
      current = {
        x = nil,
        y = nil
      },
      previous = {
        x = nil,
        y = nil
      }
    },
    direction = {
      x = player.direction.x,
      y = player.direction.y
    },
    isAlive = false
  }

  for i=1,n do
    if (player.body.size >= 0) then
      new_block.pos.current.x = player.pos.current.x + ( default_block_size * player.direction.x ) + player_body_gap
      new_block.pos.current.y = player.pos.current.y + ( default_block_size * player.direction.y ) + player_body_gap
    else
      new_block.pos.current.x = player.pos.current.x + ( ( default_block_size * player.direction.x) * (player.body.size + 1) ) + player_body_gap
      new_block.pos.current.y = player.pos.current.y + ( ( default_block_size * player.direction.y) * (player.body.size + 1) ) + player_body_gap
    end

    table.insert(player.body.blocks,new_block)

    player.body.size = player.body.size + 1

    print("Criei Corpo no Player! : ")
    print(player.body.size)

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
      if player.direction.x ~=1 and player.direction.y ~=0 then
        player.direction.x = -1
        player.direction.y = 0
      end
    elseif key == 'right' then
      if player.direction.x ~=-1 and player.direction.y ~=0 then
        player.direction.x = 1
        player.direction.y = 0
      end
    elseif key == 'up' then
      if player.direction.x ~= 0 and player.direction.y ~=1 then
          player.direction.x = 0
          player.direction.y = -1
        end
    elseif key == 'down' then
        if player.direction.x ~= 0 and player.direction.y ~=-1 then
          player.direction.y = 1
          player.direction.x = 0
        end
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
  if ( player.pos.current.x + default_block_size >= food.pos.x ) and ( player.pos.current.x <= food.pos.x + default_block_size) and ( player.pos.current.y + default_block_size >= food.pos.y) and ( player.pos.current.y <= food.pos.y + default_block_size ) then
    playerAddBlock()
    respawnPlayerFood()
  end
end

-- Jogador colidindo com ele mesmo.
function playerBodyCollision (player)
  return true
end

function love.update (dt)

  accumulator.current = accumulator.current + dt

  player.pos.previous.x = player.pos.current.x - ( default_block_size * player.direction.x )
  player.pos.previous.y = player.pos.current.y - ( default_block_size * player.direction.y )

  player.pos.current.x = player.pos.current.x + ( player.direction.x * player_movement_speed * dt )

  player.pos.current.y = player.pos.current.y + ( player.direction.y * player_movement_speed * dt )

  -- Checa colisão do Jogador.
  playerBodyCollision(player)

  if (accumulator.current >= accumulator.limit) then

    accumulator.current = accumulator.current-accumulator.limit;

    for i,block in ipairs(player.body.blocks) do

      block.pos.previous.x = block.pos.current.x
      block.pos.previous.y = block.pos.current.y

      if (i <= 1) then
        block.pos.current.x = player.pos.previous.x - player.direction.x * dt
        block.pos.current.y = player.pos.previous.y - player.direction.y * dt
      else
        block.pos.current.x = player.body.blocks[i-1].pos.previous.x - player.direction.x * dt
        block.pos.current.y = player.body.blocks[i-1].pos.previous.y - player.direction.y * dt
      end

      block.isAlive = true

    end
  end

  playerFoodCollision(player,food)

end

function drawPlayer()

  love.graphics.setColor(255, 0, 0, 180)

  -- Desenho do Jogador. ( Cabeça )
  love.graphics.rectangle( "fill", player.pos.current.x, player.pos.current.y, default_block_size, default_block_size )

  love.graphics.setColor(0, 0, 0, 255)
  -- Desenho do Corpo.
 for i,block in ipairs(player.body.blocks) do
   if (block.isAlive) then
     love.graphics.rectangle( "fill", block.pos.current.x, block.pos.current.y, default_block_size, default_block_size )
   end
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

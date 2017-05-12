screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

default_block_size = 20

high_score = 0

gameover = false

function love.load ()

  sound_eating =  love.audio.newSource("eating.wav", "static")
  sound_gameover = love.audio.newSource("gameover.wav", "static")

  -- Inicializa a Cor do Cenário
  love.graphics.setBackgroundColor(255,255,255)

  -- Inicializa a Cor das Linhas de Demarcação do Cenário.
  love.graphics.setColor(0,0, 0)

  -- Define os limites do cenário na tela. ( Xi , Yi )
  scenarioLimits = {
    10,20,
    10,screenHeight-10,
    screenWidth-10,screenHeight-10,
    screenWidth-10,20,
    10,20
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
      x = 1,
      y = 0,
    },
    body = {
      size = 0,
      speed = 1400,
      gap = 1,
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

  print("Criei Corpo do Player! : " .. tostring(player.body.size) .. "    x: " .. tostring(player.pos.current.x) .. "    y: " .. tostring(player.pos.current.y))

  -- Inicializa dois blocos ao Jogador e Inicializa comida no cenário.
  for i = 1,4 do

    initialPosX = player.pos.current.x - ( ( default_block_size + player.body.gap ) * ( player.body.size + 1 ) ) * player.direction.x

    new_block = playerAddBlockBeta(initialPosX,player.pos.current.y)

    table.insert(player.body.blocks, new_block)
  end

  -- playerAddBlock()
  respawnPlayerFood()

  accumulator = {
    current = 0,
    limit= 0.1
  }

end

function playerAddBlockBeta(x,y)

  -- Estrutura do Novo Bloco.
  new_block = {
    pos = {
      x = x,
      y = y
    },
    isAlive = true
  }

  player.body.size = player.body.size + 1

  print("Criei Corpo no Player! : " .. tostring(player.body.size) .. "    x: " .. tostring(new_block.pos.x) .. "    y: " .. tostring(new_block.pos.y))

  return new_block

end

function respawnPlayerFood()

  food.pos.x = love.math.random(20, screenWidth - 30)
  food.pos.y = love.math.random(20, screenHeight - 30)

  food.isAlive = true

end

function gameOver()

  if not gameover then
    love.audio.play( sound_gameover )
    gameover = true
    player_movement_speed = 0
  end


end

function updatescore()
  if(player.body.size > high_score) then
    high_score = player.body.size
  end
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
    player.body.speed = player.body.speed + 50
  elseif key == '1' then
    player.body.speed = player.body.speed - 50
  elseif key == 'r' and gameover then
    gameover = false
    love.load()
  end
end

-- Jogador colidindo com as paredes.
function wallCollision ()

  if player.pos.current.x <= 10 or player.pos.current.x >= screenWidth-10 - default_block_size  or player.pos.current.y <= 20  or player.pos.current.y >= screenHeight-10 -default_block_size then
    player.body.speed = 0
    gameOver()
  end
end

-- Jogador colidindo com a comida.
function blockCollision (player, food)
  if ( player.pos.current.x + default_block_size >= food.pos.x ) and ( player.pos.current.x <= food.pos.x + default_block_size) and ( player.pos.current.y + default_block_size >= food.pos.y) and ( player.pos.current.y <= food.pos.y + default_block_size ) then

    respawnPlayerFood()
    love.audio.play( sound_eating )

    return true

  else
    return false
  end
end

-- Jogador colidindo com ele mesmo.
function playerBodyCollision (player,block)
  return true
end

function love.update (dt)


  accumulator.current = accumulator.current + dt

  if (accumulator.current >= accumulator.limit and gameover == false) then

    accumulator.current = accumulator.current-accumulator.limit;

    player.pos.previous.x = player.pos.current.x
    player.pos.previous.y = player.pos.current.y

    player.pos.current.x = player.pos.current.x + ( player.direction.x * player.body.speed * dt)

    player.pos.current.y = player.pos.current.y + ( player.direction.y * player.body.speed * dt )

    for i,block in ipairs(player.body.blocks) do
      if (blockCollision(player,block) == true) then
        player.body.speed = 0
        gameOver()
      end
    end

    if (blockCollision(player,food)) then

      tail = playerAddBlockBeta(player.pos.previous.x , player.pos.previous.y)

    else

      tail = table.remove(player.body.blocks,player.body.size)

      tail.pos.x = player.pos.previous.x
      tail.pos.y = player.pos.previous.y
    end

    table.insert(player.body.blocks,1,tail)

    wallCollision()
    updatescore()
  end
end

function drawPlayer()

  love.graphics.setColor(255, 0, 0, 180)

  -- Desenho do Jogador. ( Cabeça )
  love.graphics.rectangle( "fill", player.pos.current.x, player.pos.current.y, default_block_size, default_block_size )

  love.graphics.setColor(0, 0, 0, 255)

  -- Desenho do Corpo.
  for i,block in ipairs(player.body.blocks) do
    if (block.isAlive) then
      love.graphics.rectangle( "fill", block.pos.x, block.pos.y, default_block_size, default_block_size )
    end
  end

  --Desenho do status
  love.graphics.print("Body Size " .. tostring(player.body.size) , 5, 5)
  love.graphics.print("Speed " .. tostring(player.body.speed) , 150, 5)
  love.graphics.print("High Score " .. tostring(high_score) , screenWidth-150, 5)

  love.graphics.print("x " .. tostring(player.pos.current.x) , screenWidth-150, 20)
  love.graphics.print("y " .. tostring(player.pos.current.y) , screenWidth-150, 30)
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

  if(gameover) then
    love.graphics.print("Press R to restart game",screenWidth/2 - 30,screenHeight/2)
  end
end

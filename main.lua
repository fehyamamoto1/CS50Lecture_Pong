-- https//github.com/Ulydev/push
push = require 'push'       -- this is how we import libraries

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

require 'Ball'

require 'Paddle'

--[[
    PT-BR;
    Resolução base e modo janela

    EN;
    Base resolution and window mode
]]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
GAME_WINDOW_MODE_FLAGS = {
    fullscreen = false,
    resizable = true,
    vsync = true
}

--[[
    PT-BR;
    Resolução virtual, tamanho 'simulado' dentro da resolução nativa

    EN;
    Virtual resolution
]]
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[ 
    PT-BR;
    Tamanho das raquetes

    EN;
    Padle size
]]
PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
--[[ 
    PT-BR;
    Velocidade base das raquetes, proporcionais à taxa de atualização

    EN;
    speed at which we will move our paddle; multiplied by dt in update
]]
PADDLE_SPEED = 200

-- Ball size and style
BALL_SIZE = 4
BALL_STYLE = 'fill'
BALL_SPEED_UP = 1.07

-- Score goal for the game
SCORE_GOAL = 10

--[[ 
    PT-BR;
    Função de inicialização
    Irá ser executado uma vez quando o jogo carregar a primeira vez

    EN;
    Initialization function. 
    This will be runned once when the game first loads.
]]
function love.load()
    --[[ 
        PT-BR;
        Filtro nearest-neighbor para prevenir desfoque no aumento e diminuição de escala

        EN;
        Use nearest-neighbor filtering on upscaling and downscaling to prevent blur
    ]]
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --[[
        PT-BR;
        Define o título da janela da aplicação

        EN;
        set the title of our application window
    ]]
    love.window.setTitle("Pong")

    --[[ 
        PT-BR;
        Utilização de seed para que o RNG seja artificialmente aleatório
        utilizando como base o horário do sistema para que seja diferente em cada inicialização

        EN;
        "seed" the RNG so that calls to random are always random
        use the current time, since that will vary on startup every time
    ]]
    math.randomseed(os.time())

    --[[
        PT-BR;
        Visual retro nos textos
            
        EN;
        retro-looking font used in any text
    ]]
    smallFont = love.graphics.newFont('fonts/font.ttf', 8);

    --[[
        PT-BR;
        fonte aumentada para a marcação da pontuação

        EN;
        larger font for drawing scores
    ]]
    scoreFont = love.graphics.newFont('fonts/font.ttf', 32)
    
    --[[
        PT-BR;
        inicializa os efeitos sonoros do jogo, disponibilizando em uma tabela
        que poderá ser acessada pelos indexes

        EN-US;
        initialize sound effects, later we can access then by their indexes
    ]]
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- initialize window with virtual resolution
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        GAME_WINDOW_MODE_FLAGS
    )
    
    player1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- player scores
    player1_Score = 0
    player2_Score = 0

    servingPlayer = 1

    --[[
        PT-BR;
        Utilizar o tamanho da bola ao contrário de valores fixos ajudará em mudar a escala do jogo

        EN;
        Again, using ball size as opposed to fixed value should give the game ability to change sizes
    ]]
    ball = Ball(VIRTUAL_WIDTH / 2 - BALL_SIZE / 2, VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2, BALL_SIZE, BALL_SIZE)
  
    --[[
        PT-BR;
        Estado inicial do jogo

        EN;
        Initial game state
    ]]
    gameState = 'start'
end

--[[
    PT-BR;
    Atualização ocorre de acordo com a taxa de atualização (dt) do jogo, sendo delta em segundos
    desde o último frame, sendo que este valor é dado pela game engine LOVE

    EN;
    Runs every frame, with "dt" passed in, delta in seconds
    since the last frame, which LOVE supplies
]]
function love.update(dt)
    if gameState == 'serve' then
        -- before switching to play, initialize ball's velocity based
        -- on player who last scored
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'playing' then

        --[[
            PT-BR;
            Checagem se a bola colidiu com a raquete do jogador.
            Caso a colisão seja detectado, acelera o vetor de velocidade dx em 3%
            verifica se o vetor velocidade dy é para cima (negativo)
            ou para baixo (positivo), mantendo a direção (momentum).
            Válido para ambos os jogadores.

            EN-US;
            Check if ball colided with the player.
            In case collision was detected, speed up velocity in dx
            also verifies if vector dy is pointing up (negative) or
            poiting down (positive), to maintain it's momentum.
            It's valid for both players.
        ]]
        if ball:collides(player1) then
            ball.dx = -ball.dx * BALL_SPEED_UP
            ball.x = ball.x + BALL_SIZE

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * BALL_SPEED_UP
            ball.x = ball.x - BALL_SIZE

            if ball.dy < 0 then
                ball.dy = -math.random(10.150)
            else
                ball.dy = math.random(10,150)
            end

            sounds['paddle_hit']:play()
        end

        --[[
            PT-BR;
            Verifica colisão com a parte superior da tela.
            Caso o y seja menor ou igual a zero, redefine para 0 e inverte o vetor dy.

            EN-US;
            Verifies collision with top side of screen.
            In case y is lesser than or equals zero, redefines to 0 and inverts vector dy.
        ]]
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end
        
        --[[
            PT-BR;
            Verifica colisão com a parte inferior da tela.
            Caso o y seja maior que a altura total da tela - o tamanho da bola, redefine para este
            valor e inverte o vetor dy.

            EN-US;
            Verifies collision with bottom side of screen.
            In case y is greater than total height - ball size, redefines to this value and inverts 
            vector dy.
        ]]
        if ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
            ball . y = VIRTUAL_HEIGHT - BALL_SIZE
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end
    end

    if ball.x < 0 then
        servingPlayer = 1
        player2_Score = player2_Score + 1
        ball:reset()
        gameState = 'start'

        sounds['score']:play()

        if player2_Score == SCORE_GOAL then
            winningPlayer = 2
            gameState = 'done'
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2
        player1_Score = player1_Score + 1
        ball:reset()
        gameState = 'start'

        sounds['score']:play()

        if player1_Score == SCORE_GOAL then
            winningPlayer = 1
            gameState = 'done'
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    --[[
        PT-BR;
        Movimentação do jogador 1

        EN;
        Player 1 movement
    ]]
    if love.keyboard.isDown('w') then
        --[[
            PT-BR;
            Adiciona velocidade negativa para a coordenada Y, proporcional ao dt
            Move-se para cima.

            EN;
            Add negative paddle speed to current Y scaled by dt, moves up
        ]]
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        --[[
            PT-BR;
            Adiciona velocidade positiva para o eixo Y, proporcioanl ao dt
            Move-se para baixo. 

            EN;
            Add positive paddle speed to current Y scaled by dt, moves down
        ]]
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    --[[
        PT-BR;
        Movimentação do jogador 2

        EN;
        Player 2 movement
    ]]
    if love.keyboard.isDown('up') then
        --[[
            PT-BR;
            Adiciona velocidade negativa para a coordenada Y, proporcional ao dt
            Move-se para cima.

            EN;
            Add negative paddle speed to current Y scaled by dt, moves up
        ]]
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
         --[[
            PT-BR;
            Adiciona velocidade positiva para o eixo Y, proporcioanl ao dt
            Move-se para baixo. 

            EN;
            Add positive paddle speed to current Y scaled by dt, moves down
        ]]
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    --[[
        PT-BR;
        Movimentação da bola
        Irá movimentar-se apenas quando o jogo iniciar, ou seja, no estado de "playing" (jogando)

        EN;
        ball movement
        will only move when game begins
    ]]
    if gameState == 'playing' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end


--[[
    PT-BR;
    O Framework LOVE2D chama essa função todo frame 
    O propósito da função é passar a tecla pressionada para que ela possa ser acessada
    As teclas devem ser acessadas por uma string contendo seu nome

    EN;
    LOVE2D will call this function every frame
    will pass the key we pressed so it can be accessed
    keys can be accessed via string name
]]
function love.keypressed(key)
    --[[
        PT-BR;
        encerra o jogo quando a tecla `esc` é pressionada

        EN;
        quit game when esc key is pressed 
    ]]
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'playing'
        elseif gameState == 'serve' then
            gameState= 'playing'
        elseif gameState == 'done' then
            --[[
                PT-BR;
                Caso o jogo já esteja rodando, define o estado de jogo como `start` 
                e redefine a posição da bola

                EN;
                in case game is already running, defines game state as `start`
                and resets the ball
            ]]
            gameState = 'serve'

            ball:reset()

            player1_Score = 0
            player2_Score = 0

            -- decide serving player as the opposite of who won
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end 
    end
end

function love.draw()
    --[[
        PT-BR;
        Inicia a renderização com a resolução virtual definida

        EN;
        begin rendering at virtual resolution
    ]]
    push:apply('start')

    -- clear screen with specific color
    love.graphics.clear(167/255, 40/255, 145/255, 255/255)

    -- set game font to desired retro-looking font
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        -- draw welcome text toward the top of the screen
    love.graphics.printf(string.format('Score %d to win', SCORE_GOAL), 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end


    -- draw player scores
    displayScore()
    -- render left side paddle
    player1:render()

    -- render right side paddle
    player2:render()

    -- render ball 
    ball:render()

    displayFPS()

    -- end rendering at virtual resolution
    push:apply('end')
end

function love.resize(w, h)
    push:resize(w, h)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1_Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2_Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end
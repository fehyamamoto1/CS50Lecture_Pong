Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    --[[
        PT-BR;
        Velocidade vetorial da bola. 
        Destaque para o ternário em lua, com o formato: <condição> and <valor_se_verdadeiro> or <valor_se_falso>

        EN;
        ball vectorial speed
        lua's ternary, with the format: <condition> and <value_if_true> or <value_if_false>  
    ]] 
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Ball:reset()
    --[[
        PT-BR;
        Dividimos o valor da bola por 2 ao invés de fixar o valor 2. Desta forma, garantimos 
        que quando alterarmos o valor da bola, o posicionamento dela ainda é centralizado 
        (o começo do objeto irá estar na matade da tela - a metade de seu tamanho)

        EN;
        dividing the size of the ball by 2 instead of fixing value 2 should give us the freedom to choose ball size
    ]]
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    --[[
        PT-BR
        Reseta a velocidade vetorial da bola

        EN;
        reset ball vectorial speed
    ]]
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

--[[
    PT-BR;
    Aplica velocidade à posição da bola, proporcional à taxa de atualização delta (dt)

    EN;
    Applies velocity to position, scaled by delta time (dt)
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

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
    self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
end

function Ball:collides(paddle)
    --[[
        PT-BR;
        Colisão AABB, primeiramente verificamos o eixo X.
        Caso a posição X da bola seja maior que a posição X da raquete + sua largura, então a bola está em uma posição maior
        que a lateral direita da raquete.
        Caso a posição X da raquete seja maior que posição X da bola + sua largura, então a bola está em uma posição
        menor que a lateral esquerda da raquete.
        Dessa forma, cobrimos ambas as laterais, tanto de uma colisão pela direita quanto uma colisão pela esquerda.

        EN-US;
        AABB collision. First, verify the X axys.
        In case the ball's X coordinate is greater than the X coordinate of paddle + width, then the ball is in a position
        to the right side of the paddle, not colliding from this side.
        In case the paddle's X coordinate is greater than the X coordinate of the ball + width, then the ball is in a position
        to the left side of the paddle, not colliding from this side.
        This way, we are covering the collision from both sides.
    ]]
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    --[[
        PT-BR;
        Similar à lógica do eixo X.
        Se a posição Y da bola for maior que a posição Y da raquete + sua altura, a bola está abaixo da raquete
        e não há colisão.
        Se a posição Y da raquete for maior que a posição Y da bola + sua altura, a bola está acima da raquete
        e não há colisão.

        EN-US;
        Similarly, if the ball's Y position is greater than paddle's Y position + height, the ball is below the paddle
        and there's no collision.
        If the paddle's Y position is greater than ball's Y position + height, the ball is above the paddle and there's
        no collision.
    ]]
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    --[[
        PT-BR;
        Se nenhuma condição anterior for cumprida, significa que há colisão.

        EN-US;
        If none of the conditions was met, then collision was detected;
    ]]
    return true
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
    self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
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

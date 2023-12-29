Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end


function Paddle:update(dt)
    if self.dy < 0 then
        --[[
            PT-BR;
            O método irá trazer o maior valor entre 0 e a posição atual da 'raquete'
            A posição na tela é dado na orientação cima-baixo, esquerda-direita.
            Isso quer dizer que o topo esquerdo da tela é o p(0,0), 
            e o valor de y cresce para baixo e o de x para a direita. 
            Dessa forma, a raquete não irá atravessar o limite superior da tela 
            (lembrando que a posição do objeto na tela é dado pelo ponto superior-esquerdo)

            EN;
            Simply put, screen position is from top to bottom left to right
            this will ensure that our position is greater than 0.
            Will get the highest value between 0 and player position
        ]]
        self.y = math.max(0, self.y + self.dy * dt)
    else
        --[[
            PT-BR;
            O método garante que a posição da raquete não irá atravessar o limite inferior da tela.
            Como dito antes, a posição do objeto é dado pelo ponto superior-esquerdo. Dessa forma,
            o valor máximo que a posição pode atingir é o tamanho da tela - o tamanho do objeto, 
            fazendo com que ele fique inteiramente dentro da tela, não atravessando parcialmente a borda
            inferior.
            Irá escolher entre o valor menor: a posição da tela - o tamanho da raquete ou a posição atual da raquete. 

            EN;
            This will ensure that we are in a position lesser than the screen size 
            so we don't pass the bottom edge of the screen
            Will get the lowest value between the height of the screen minus paddle size 
            (so it's fully inside the screen) or the player position 
            the position is given by the lowest point in the paddle 
        ]]
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
-- https//github.com/Ulydev/push
push = require 'push'       -- this is how we import libraries

-- Base resolution and window mode
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
GAME_WINDOW_MODE_FLAGS = {
    fullscreen = false,
    resizable = false,
    vsync = true
}

-- Virtual resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Padle size and style
PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_STYLE = 'fill'

-- Ball size and style
BALL_SIZE = 4
BALL_STYLE = 'fill'

--[[ 
    Initialization function. 
    This will be runned once when the game first loads.
]]
function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blur
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- retro-looking font 
    smallFont = love.graphics.newFont('fonts/font.ttf', 8);

    -- set game font to desired retro-looking font
    love.graphics.setFont(smallFont)

    -- initialize window with virtual resolution
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        GAME_WINDOW_MODE_FLAGS
    )
end

--[[
    LOVE2D will call this function every frame
    will pass the key we pressed so it can be accessed
]]
function love.keypressed(key)
    -- keys can be accessed via string name
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- clear screen with specific color
    love.graphics.clear(167/255, 40/255, 145/255, 255/255)

    -- draw welcome text toward the top of the screen
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- render left side paddle
    love.graphics.rectangle(PADDLE_STYLE, 10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- render right side paddle
    love.graphics.rectangle(PADDLE_STYLE, VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- render ball 
    love.graphics.rectangle(BALL_STYLE, VIRTUAL_WIDTH / 2 - BALL_SIZE / 2, VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2, BALL_SIZE, BALL_SIZE)

    -- end rendering at virtual resolution
    push:apply('end')
end


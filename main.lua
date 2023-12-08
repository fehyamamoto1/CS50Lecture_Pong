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
-- speed at which we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200

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
    
    -- retro-looking font used in any text
    smallFont = love.graphics.newFont('fonts/font.ttf', 8);

    -- larger font for drawing scores
    scoreFont = love.graphics.newFont('fonts/font.ttf', 32)

    -- initialize window with virtual resolution
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        GAME_WINDOW_MODE_FLAGS
    )

    -- player scores
    player1_Score = 0
    player2_Score = 0

    -- paddle positions in Y axis 
    player1_Y = 30
    player2_Y = VIRTUAL_HEIGHT - 50
end

--[[
    Runs every frame, with "dt" passed in, delta in seconds
    since the last frame, which LOVE supplies
]]
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by dt, moves up
        player1_Y = player1_Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by dt, moves down
        player1_Y = player1_Y + PADDLE_SPEED * dt
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current y scaled by dt, moves up 
        player2_Y = player2_Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2_Y = player2_Y + PADDLE_SPEED * dt
    end
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

    -- set game font to desired retro-looking font
    love.graphics.setFont(smallFont)

    -- draw welcome text toward the top of the screen
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- draw player scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1_Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2_Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)

    -- render left side paddle
    love.graphics.rectangle(PADDLE_STYLE, 10, player1_Y, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- render right side paddle
    love.graphics.rectangle(PADDLE_STYLE, VIRTUAL_WIDTH - 10, player2_Y, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- render ball 
    love.graphics.rectangle(BALL_STYLE, VIRTUAL_WIDTH / 2 - BALL_SIZE / 2, VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2, BALL_SIZE, BALL_SIZE)

    -- end rendering at virtual resolution
    push:apply('end')
end
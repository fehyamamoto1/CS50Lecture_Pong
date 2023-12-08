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

--[[ 
    Initialization function. 
    This will be runned once when the game first loads.
]]
function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blur
    love.graphics.setDefaultFilter(
        'nearest',
        'nearest'
    )

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

    -- using virtual height and width for text placement
    love.graphics.printf(
        "Hello Pong!",          -- text to render
        0,                      -- starting X (it will be centralized so beginning from the center, X = 0)
        VIRTUAL_HEIGHT / 2 - 6,  -- starting Y (halfway down the screen minus half of the default font size in this case)
        VIRTUAL_WIDTH,           -- number of pixels to center within (read: center in a resolution with a width of WINDOWS_WIDTH pixels)
        "center"                -- alignment mode: 'center', 'left', 'right'
    )

    push:apply('end')
end


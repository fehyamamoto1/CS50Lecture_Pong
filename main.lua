WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

GAME_WINDOW_MODE_FLAGS = {
    fullscreen = false,
    resizable = false,
    vsync = true
}

--[[ 
    Initialization function. 
    This will be runned once when the game first loads.
]]

function love.load()
    love.window.setMode(
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        GAME_WINDOW_MODE_FLAGS
    )
end

function love.draw()
    love.graphics.printf(
        "Hello Pong!",          -- text to render
        0,                      -- starting X (it will be centralized so beginning from the center, X = 0)
        WINDOW_HEIGHT / 2 - 6,  -- starting Y (halfway down the screen minus half of the default font size in this case)
        WINDOW_WIDTH,           -- number of pixels to center within (read: center in a resolution with a width of WINDOWS_WIDTH pixels)
        "center"                -- alignment mode: 'center', 'left', 'right'
    )
end


-- Callbacks for key pressed, in case we spread over multiple files
love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

require 'ui/Panel'
require 'ui/ProgressBar'
require 'ui/Scrollbar'
require 'ui/Selection'
require 'ui/Textbox'
push = require 'push'

require 'code/states/ExploreState'
require 'code/states/WaitState'
require 'code/states/MoveState'
require 'code/states/NPCStandState'
require 'code/states/PlanStrollState'

require 'Character'
require 'Entity'
require 'EntityDefs'
require 'small_room'
require 'Map'
require 'StateMachine'
require 'StateStack'
require 'Vector'

virtualWidth = 384
virtualHeight = 216

love.graphics.setFont(love.graphics.newFont('fonts/04B_03__.TTF', 8))

local stack, mapDef, state

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    stack = StateStack:Create()
    mapDef = CreateMap1()
    mapDef.on_wake = {}
    mapDef.actions = {}
    mapDef.trigger_types = {}
    mapDef.triggers = {}

    state = ExploreState:Create(nil, mapDef, Vector:Create(11, 3, 1))
    stack:Push(state)
    stack:PushFit(0, 0, "You're trapped in a small room.")

    push:setupScreen(virtualWidth, virtualHeight, 1280, 720, {
        fullscreen = false,
        resizable = true
    })

    print('Game loaded!')
end

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.update(dt)
    stack:Update(dt)
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    require('lurker').update()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'tab' then
        love.load()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.draw()
    push:apply('start')
    stack:Render()
    push:apply('end')
end

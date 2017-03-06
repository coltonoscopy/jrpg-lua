Character = {}
Character.__index = Character

function Character:Create(def, map)
    -- look up the entity
    local entityDef = gEntities[def.entity]
    assert(entityDef) -- the entity def should always exist

    local this = {
        mEntity = Entity:Create(entityDef),
        mAnims = def.anims,
        mFacing = def.facing
    }

    setmetatable(this, self)

    -- create the controller states from the def
    local states = {}
    -- make the controller state machine from the states
    this.mController = StateMachine:Create(states)

    for _, name in ipairs(def.controller) do
        local state = gCharacterStates[name]
        assert(state)
        assert(states[state.mName] == nil) -- state already in use!
        local instance = state:Create(this, map)
        states[state.mName] = function() return instance end
    end

    this.mController.states = states

    -- change the state machine to the initial state
    -- as defined in the def
    this.mController:Change(def.state)

    return this
end

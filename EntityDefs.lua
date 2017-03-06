assert(WaitState)
assert(MoveState)

gCharacterStates = {
    wait = WaitState,
    move = MoveState,
    npc_stand = NPCStandState
}

gEntities = {
    hero = {
        texture = 'graphics/walk_cycle.png',
        width = 16,
        height = 24,
        startFrame = 9,
        tileX = 11,
        tileY = 3,
        layer = 1
    }
}

gCharacters = {
    standing_npc = {
        entity = 'hero',
        anims = {},
        facing = 'down',
        controller = {'npc_stand'},
        state = 'npc_stand'
    },
    hero = {
        entity = 'hero',
        anims = {
            up      = {1, 2, 3, 4},
            right   = {5, 6, 7, 8},
            down    = {9, 10, 11, 12},
            left    = {13, 14, 15, 16}
        },
        facing = 'down',
        controller = {'wait', 'move'},
        state = 'wait'
    }
}

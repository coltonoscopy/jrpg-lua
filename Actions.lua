Actions = {
    -- Teleport an entity from the current position to the given position
    Teleport = function(map, tileX, tileY)
        return function(trigger, entity)
            entity.mTileX = tileX
            entity.mTileY = tileY
            Teleport(entity, map)
        end
    end
}

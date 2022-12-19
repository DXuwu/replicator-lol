return function(_, CanEntityKill, _, _, _, spawnEntity, entities)
    for _, entity in pairs(entities.RegularEntities) do
        if entity~="All" and entity~="Random" and entity~="None" then
            spawnEntity(entity)
        end
    end
end
-- Este archivo es parte del proyecto fzt_Fov.
-- Copyright (c) 2025 fourztL. Todos los derechos reservados.
-- Este proyecto está distribuido bajo la Licencia Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0).
-- Para más detalles, consulta el archivo LICENSE.

local minDistance, maxDistance = 0.20, 20.0


entidadAtras = function(entity)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    local entityCoords = GetEntityCoords(entity)
    local direction = GetEntityForwardVector(playerPed)

    local toEntity = vector3(entityCoords.x - playerCoords.x, entityCoords.y - playerCoords.y, 0.0)
    local dotProduct = direction.x * toEntity.x + direction.y * toEntity.y
    return dotProduct < 0.0 
end

aplicarTransparencia = function(entity, alpha)
    if DoesEntityExist(entity) then
        SetEntityAlpha(entity, alpha, false)
    end
end

resetVisibilidad = function(entity)
    if DoesEntityExist(entity) then
        ResetEntityAlpha(entity)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearbyEntities = {}

        for _, ped in ipairs(GetGamePool('CPed')) do
            if ped ~= playerPed and DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                table.insert(nearbyEntities, ped)
            end
        end

        for _, playerId in ipairs(GetActivePlayers()) do
            local otherPed = GetPlayerPed(playerId)
            if otherPed ~= playerPed and DoesEntityExist(otherPed) then
                table.insert(nearbyEntities, otherPed)
            end
        end

        for _, entity in ipairs(nearbyEntities) do
            local distance = #(GetEntityCoords(entity) - playerCoords)

            if entidadAtras(entity) then
                if distance <= minDistance then
                    aplicarTransparencia(entity, 220)
                elseif distance <= maxDistance then
                    local alpha = 220 * (1 - (distance - minDistance) / (maxDistance - minDistance))
                    aplicarTransparencia(entity, math.floor(math.max(0, math.min(220, alpha))))
                else
                    aplicarTransparencia(entity, 0)
                end
            else
                resetVisibilidad(entity)
            end
        end
    end
end)

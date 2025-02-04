-- Este archivo es parte del proyecto fzt_Fov.
-- Copyright (c) 2025 fourztL. Todos los derechos reservados.
-- Este proyecto está distribuido bajo la Licencia Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0).
-- Para más detalles, consulta el archivo LICENSE.

local QBCore = exports['qb-core']:GetCoreObject()

-- Agrega la tabla a tu Database
exports.oxmysql:execute([[
    ALTER TABLE players
    ADD COLUMN esMiope TINYINT(1) NOT NULL DEFAULT 0;
]], {}, function(result)
    if result then
        print("Campo 'esMiope' agregado correctamente a la tabla 'players'.")
    else
        print("Error al agregar el campo 'esMiope'.")
    end
end)


-- Evento para cargar los datos del jugador al iniciar sesión
RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Consultar el estado de miopía desde la base de datos
    exports.oxmysql:execute('SELECT esMiope FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
        if result and result[1] then
            local esMiope = result[1].esMiope == 1
            Player.Functions.SetMetaData("esMiope", esMiope)
            TriggerClientEvent('fzt_fov:setMiopia', src, esMiope)
        else
            local esMiope = false
            Player.Functions.SetMetaData("esMiope", esMiope)
            TriggerClientEvent('fzt_fov:setMiopia', src, esMiope)
        end
    end)
end)

-- Comando para cambiar el estado de miopía (opcional, para pruebas)
QBCore.Commands.Add("setmiopia", "Establecer estado de miopía", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    local esMiope = tonumber(args[1]) == 1
    Player.Functions.SetMetaData("esMiope", esMiope)

    -- Guardar el cambio en la base de datos usando oxmysql
    exports.oxmysql:execute('UPDATE players SET esMiope = ? WHERE citizenid = ?', {esMiope and 1 or 0, Player.PlayerData.citizenid})

    TriggerClientEvent('fzt_fov:setMiopia', source, esMiope)
    TriggerClientEvent("QBCore:Notify", source, "Miopía " .. (esMiope and "activada" or "desactivada"), "success")
end)

-- Evento para actualizar el estado de los lentes desde el qb-radialmenu
RegisterNetEvent("fzt_fov:updateGlasses", function(drawable, texture)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local props = Player.PlayerData.metadata["props"] or {}
    props["glasses"] = { drawable = drawable, texture = texture }

    Player.Functions.SetMetaData("props", props)

    local isWearingGlasses = drawable ~= 0 and drawable ~= -1
    TriggerClientEvent("fzt_fov:setGlassesState", src, isWearingGlasses)

    --print("Lentes actualizados (radial menu). Drawable:", drawable, "Texture:", texture)
end)
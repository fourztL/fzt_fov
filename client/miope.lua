-- Este archivo es parte del proyecto fzt_Fov.
-- Copyright (c) 2025 fourztL. Todos los derechos reservados.
-- Este proyecto está distribuido bajo la Licencia Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0).
-- Para más detalles, consulta el archivo LICENSE.


local blurEffectEnabled = false
local wearingGlasses = false


-- Función para aplicar el efecto de visión borrosa
ApplyBlurEffect = function(enabled)
    if enabled then
        SetTimecycleModifier("Drunk")
        SetTimecycleModifierStrength(0.8)
        TriggerScreenblurFadeIn(3500) -- Desenfoque de pantalla
        --print("Efecto de visión borrosa activado.")
    else
        ClearTimecycleModifier()
        TriggerScreenblurFadeOut(500) -- Quitar el desenfoque de pantalla
        --print("Efecto de visión borrosa desactivado.")
    end
end

-- Función para verificar si el jugador está usando lentes
IsWearingGlasses = function()
    local ped = PlayerPedId()
    local drawable = GetPedPropIndex(ped, 1) 
    local texture = GetPedPropTextureIndex(ped, 1)

    return drawable ~= 0 and drawable ~= -1
end

-- Evento para recibir el estado inicial de miopía
RegisterNetEvent("fzt_fov:setMiopia", function(esMiope)
    --print("Estado de miopía recibido:", esMiope)
    blurEffectEnabled = esMiope
    ApplyBlurEffect(blurEffectEnabled and not wearingGlasses)
end)

-- Evento para recibir el estado inicial de los lentes
RegisterNetEvent("fzt_fov:setGlassesState", function(isWearingGlasses)
    --print("Estado de los lentes recibido:", isWearingGlasses)
    wearingGlasses = isWearingGlasses
    ApplyBlurEffect(blurEffectEnabled and not wearingGlasses)
end)

TriggerServerEvent("fzt_fov:checkGlasses")


-- Monitorear cambios en el equipamiento del jugador
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if blurEffectEnabled then
            wearingGlasses = IsWearingGlasses()
            ApplyBlurEffect(blurEffectEnabled and not wearingGlasses)
        else
            Citizen.Wait(5000)
        end
    end
end)
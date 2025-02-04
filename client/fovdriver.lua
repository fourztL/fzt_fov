-- Este archivo es parte del proyecto fzt_Fov.
-- Copyright (c) 2025 fourztL. Todos los derechos reservados.
-- Este proyecto está distribuido bajo la Licencia Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0).
-- Para más detalles, consulta el archivo LICENSE.

local cameraActive = false
local cam = nil
local pitch, offsetYaw = 0.0, 0.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5) 
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped and GetFollowVehicleCamViewMode() == 4 then
            if not cameraActive then
                cameraActive = true
                cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                AttachCamToPedBone(cam, ped, GetPedBoneIndex(ped, 12844), 0.0, 0.0, 0.65, 0.0)
                SetCamFov(cam, 90.0)
                SetCamNearClip(cam, 0.09)
                RenderScriptCams(true, true, 1000, true, true)
            end

            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)

            local mouseX, mouseY = GetDisabledControlNormal(0, 1), GetDisabledControlNormal(0, 2)
            offsetYaw = math.max(-90.0, math.min(90.0, offsetYaw - mouseX * 5.0))
            pitch = math.max(-40.0, math.min(40.0, pitch - mouseY * 5.0))

            SetCamRot(cam, pitch, 0.0, GetEntityHeading(vehicle) + offsetYaw, 2)
        else
            if cameraActive then
                cameraActive = false
                RenderScriptCams(false, false, 0, true, false)
                DestroyCam(cam, false)
                cam = nil
            end
        end
    end
end)
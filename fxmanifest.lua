fx_version 'cerulean'
game 'gta5'

author 'Arilson'
description 'Remove NPCs/tráfego'
version '1.0.0'

client_script 'client.lua'

-- client.lua
-- Roda como client, a cada tick força densidades para 0 e remove peds aleatórios
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- roda todo frame

        -- Densidade de pedestres
        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)

        -- Remove peds próximos (opcional – cuidado com players)
        local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(playerPed, true))
        local radius = 60.0 -- raio em metros para "limpar" peds (ajusta se quiser)
        local handle, ped = FindFirstPed()
        local success
        repeat
            local pedCoords = GetEntityCoords(ped)
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                local dist = #(pedCoords - vector3(px, py, pz))
                if dist <= radius then
                    -- garante que não mate peds que fizerem parte de scripts legit (use com cuidado)
                    if not IsEntityAMissionEntity(ped) and not IsPedInAnyVehicle(ped, false) then
                        DeleteEntity(ped)
                    end
                end
            end
            success, ped = FindNextPed(handle)
        until not success
        EndFindPed(handle)

        -- Opcional: para evitar barcos ou veículos específicos
        -- SetGarbageTrucks(false)
        -- SetAllVehicleGeneratorsActiveInArea(px - 200.0, py - 200.0, pz - 200.0, px + 200.0, py + 200.0, pz + 200.0, false, false)

        -- Desativa cenários (pessoas sentadas, mexendo no celular etc.)
        ClearAreaOfCops(px, py, pz, 100.0) -- remove polícias ambulantes, cuidado com uso
    end
end)
ensure no_npcs

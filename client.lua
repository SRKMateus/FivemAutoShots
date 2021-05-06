RegisterCommand(srkPhoto.carcommand,function()
    if srkPhoto.customPosition then
        local ped = GetPlayerPed(-1)
        SetEntityCoords(ped, srkPhoto.playerCoords.x, srkPhoto.playerCoords.y, srkPhoto.playerCoords.z, false, false, false, true)
        SetEntityHeading(ped, srkPhoto.playerHeading)
        SetGameplayCamRelativeHeading(0)
        Citizen.Wait(2000)
    end
    SetFollowPedCamViewMode(4)
    Citizen.Wait(2000)
    for k,v in pairs(srkPhoto.list) do
        local name = v
        local mhash = GetHashKey(name)
        while not HasModelLoaded(mhash) do
            RequestModel(mhash)
            Citizen.Wait(10)
        end
        if HasModelLoaded(mhash) then
            local ped = PlayerPedId()
            local nveh = CreateVehicle(mhash,srkPhoto.coords,srkPhoto.heading,true,false)
            SetVehicleDirtLevel(nveh,0)
            Citizen.Wait(500)
            TriggerServerEvent('TakeScreenShotSRK',name)
            Citizen.Wait(500)
            DeleteVehicle(nveh)
            Citizen.Wait(500)
        end
    end
end)

RegisterCommand(srkPhoto.clothescommand,function(source,args)
    local selectedSexo
    local selectedSexo2
    local selectedSexo3
    if args[1] == 'M' or args[1] == 'm'  then
        selectedSexo = `mp_m_freemode_01`
        selectedSexo2 = 1
        selectedSexo3 = 'MaleM'
    elseif args[1] == 'F' or args[1] == 'f'  then
        selectedSexo = `mp_f_freemode_01`
        selectedSexo2 = 2
        selectedSexo3 = 'FemaleF'
    else
        alert('Especifique um sexo')
        return
    end
    if args[2] then
        if srkPhoto.commandConfigs[args[2]] then
            local ped = PlayerPedId()
            while not HasModelLoaded(selectedSexo) do
                RequestModel(selectedSexo)
                Citizen.Wait(10)
            end
            local clonePed = CreatePed(4,selectedSexo,-203.15, -1328.24, 33.9, 78.00 , false, false)
            SetPedComponentVariation(clonePed,8,srkPhoto.defaultUndershirt[selectedSexo2],0,0)
            SetPedComponentVariation(clonePed,3,srkPhoto.defaultHands[selectedSexo2],0,0)
            SetPedComponentVariation(clonePed,4,srkPhoto.defaultLeg[selectedSexo2],0,0)
            SetPedComponentVariation(clonePed,11,srkPhoto.defaultShirt[selectedSexo2],0,0)
            SetPedComponentVariation(clonePed,6,srkPhoto.defaultShoes[selectedSexo2],0,0)
            FreezeEntityPosition(clonePed,true)
            if srkPhoto.commandConfigs[args[2]][3] == 'upcam' then
                upcam()
            elseif srkPhoto.commandConfigs[args[2]][3] == 'lowercam' then
                lowercam()
            elseif srkPhoto.commandConfigs[args[2]][3] == 'shoescam' then
                shoescam()
            else
                alert('Especifique a peça de roupa')
                return
            end
            local counter = srkPhoto.commandConfigs[args[2]][2]
            while counter > 0 do
                counter = counter-1
                if string.match(srkPhoto.commandConfigs[args[2]][1],'p') then
                    local propIndex,_ = string.gsub(srkPhoto.commandConfigs[args[2]][1],'p','')
                    SetPedPropIndex(clonePed,tonumber(propIndex),counter,0,true)
                else
                    SetPedComponentVariation(clonePed,srkPhoto.commandConfigs[args[2]][1],counter,0,0)
                end
                Citizen.Wait(1000)
                TriggerServerEvent('TakeScreenShotSRK',srkPhoto.commandConfigs[args[2]][1]..selectedSexo3..'('..counter..')')
            end
            DeleteEntity(clonePed)
            destroyCam()
        end
    end
end)

local camera
function upcam()
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 500, true, true)
    SetCamCoord(camera, -204.21, -1328.02, 35.2)
    PointCamAtCoord(camera, -203.15, -1328.24, 35.2)
end

function lowercam()
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 500, true, true)
    SetCamCoord(camera, -204.21, -1328.02, 34.6)
    PointCamAtCoord(camera, -203.15, -1328.24, 34.6)
end

function shoescam()
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 500, true, true)
    SetCamCoord(camera, -204.21, -1328.02, 34.3)
    PointCamAtCoord(camera, -203.15, -1328.24, 34.0)
end

function destroyCam()
    SetCamActive(camera, false)
    RenderScriptCams(false, true, 0, true, true)
    camera = nil
end

function alert(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
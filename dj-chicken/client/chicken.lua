DJCore = nil
local PlayerData                = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if DJCore == nil then
            TriggerEvent('DJCore:GetObject', function(obj) DJCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = false
local PlayerJob = {}
local notInteressted = false


RegisterNetEvent('DJCore:Client:OnPlayerLoaded')
AddEventHandler('DJCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = DJCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('DJCore:Client:OnPlayerUnload')
AddEventHandler('DJCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('DJCore:Client:OnJobUpdate')
AddEventHandler('DJCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end


Citizen.CreateThread(function()
    if Config.NPCEnable == true then
        for i, v in pairs(Config.NPC) do
            RequestModel(v.npc)
            while not HasModelLoaded(v.npc) do
                Wait(1)
            end
            chickenped = CreatePed(1, v.npc, v.x, v.y, v.z, v.h, false, true)
            SetBlockingOfNonTemporaryEvents(chickenped, true)
            SetPedDiesWhenInjured(chickenped, false)
            SetPedCanPlayAmbientAnims(chickenped, true)
            SetPedCanRagdollFromPlayerImpact(chickenped, false)
            SetEntityInvincible(chickenped, true)
            FreezeEntityPosition(chickenped, true)
        end
    end
end)

function Animation() 
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common")do 
        Citizen.Wait(0)
    end;b=CreateObject(GetHashKey('prop_weed_bottle'),0,0,0,true)
    AttachEntityToEntity(b,PlayerPedId(),
    GetPedBoneIndex(PlayerPedId(),57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
    AttachEntityToEntity(p,l,GetPedBoneIndex(l,57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
    TaskPlayAnim(GetPlayerPed(-1),"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)
    TaskPlayAnim(l,"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)
    Wait(1550)
    DeleteEntity(b)
    ClearPedTasks(pid)
    ClearPedTasks(l)
end

--tavukları yakala
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(2)
        local sleep = true
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k,v in pairs(Config.Chickens) do
            if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 5 then
            sleep = false
            if not notInteressted then
			DrawText3D( v.x, v.y, v.z, "[E] Catch Chickens", 0.7)
            if IsControlJustPressed(1, 38) then
                TavukYakala()
                    notInteressted = true
                    SetTimeout(4000, ClearTimeOut)
                DJCore.Functions.Notify("Catching Chickens!", "success")	
                Citizen.Wait(1500)		
                TriggerServerEvent("dinjer_chicken:chicken", "alive_chicken")
			end
		   end
        end
        if sleep then
            Citizen.Wait(1000)
          end
          Citizen.Wait(3)

	end
end)

function TavukYakala()
	local playerPed = GetPlayerPed(-1)
        LoadAnim("random@domestic")
        FreezeEntityPosition(GetPlayerPed(-1),true)
        TaskPlayAnim(playerPed, 'random@domestic', 'pickup_low', 8.0, -8, -1, 48, 0, 0, 0, 0)
        Citizen.Wait(1000)
        DJCore.Functions.Progressbar("djchicken", "Tavukları Yakalıyorsun...", 3500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done 
            ClearPedTasksImmediately(ped)
            FreezeEntityPosition(playerPed, false)
            TriggerServerEvent('dinjer_chicken:chicken')

	end)	
end
--will add illegal chicken cathing, if players not slaughterer, will be report to police.

--tavukları yakala son

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(2)
        local sleep = true
        if not notInteressted then
        if isLoggedIn and DJCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == Config.job then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["butcher"].coords.x, Config.Locations["butcher"].coords.y, Config.Locations["butcher"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["butcher"].coords.x, Config.Locations["butcher"].coords.y, Config.Locations["butcher"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["butcher"].coords.x, Config.Locations["butcher"].coords.y, Config.Locations["butcher"].coords.z, true) < 1.5) then
                        sleep = false
                            DrawText3D(Config.Locations["butcher"].coords.x, Config.Locations["butcher"].coords.y, Config.Locations["butcher"].coords.z, "~g~E~w~ - Tavukları Kes ")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TavukKes()
                            notInteressted = true
                            SetTimeout(15000, ClearTimeOut)
                        end
                     end
                end
            end
        else
            Citizen.Wait(5000)
        end
        if sleep then
            Citizen.Wait(1000)
          end
          Citizen.Wait(3)

    end
end)


function TavukKes()
    local ped = GetPlayerPed(-1)
    local playerPed = PlayerPedId()
    local PedCoords = GetEntityCoords(GetPlayerPed(-1))
    LoadAnim("anim@amb@business@coc@coc_unpack_cut_left@")
    FreezeEntityPosition(GetPlayerPed(-1),true)
    TaskPlayAnim(GetPlayerPed(-1), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
    bicak = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
    AttachEntityToEntity(bicak, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
    SetEntityHeading(GetPlayerPed(-1), 311.0)
    tavuk = CreateObject(GetHashKey('prop_int_cf_chick_01'),-94.87, 6207.008, 30.08, true, true, true)
    SetEntityRotation(tavuk,90.0, 0.0, 45.0, 1,true)

	DJCore.Functions.Progressbar("djchicken", "Tavukları Kesiyorsun...", 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done    
   -- 
    DeleteEntity(tavuk)
    DeleteEntity(bicak)
    DeleteEntity(tavuk)
    DeleteEntity(bicak)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(playerPed, false)
    TriggerServerEvent('dinjer_chicken:catch')
    end)
end
--tavuk kesme son

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(2)
        local sleep = true
        if not notInteressted then
        if isLoggedIn and DJCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == Config.job then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["packing"].coords.x, Config.Locations["packing"].coords.y, Config.Locations["packing"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["packing"].coords.x, Config.Locations["packing"].coords.y, Config.Locations["packing"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["packing"].coords.x, Config.Locations["packing"].coords.y, Config.Locations["packing"].coords.z, true) < 1.5) then
                        sleep = false
                            DrawText3D(Config.Locations["packing"].coords.x, Config.Locations["packing"].coords.y, Config.Locations["packing"].coords.z, "~g~E~w~ - Tavukları Paketle")
                        if IsControlJustReleased(0, Keys["E"]) then
                                TavukPaket()
                                notInteressted = true
                                SetTimeout(16000, ClearTimeOut)
                        end
                     end
                end
            end
        else
            Citizen.Wait(5000)
        end
        if sleep then
            Citizen.Wait(1000)
          end
        Citizen.Wait(3)

    end
end)

function TavukPaket()
    local ped = GetPlayerPed(-1)
    local playerPed = PlayerPedId()
	SetEntityHeading(GetPlayerPed(-1), 40.0)
    local PedCoords = GetEntityCoords(GetPlayerPed(-1))
    
    tavuket = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(tavuket, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	karton = CreateObject(GetHashKey('prop_cs_clothes_box'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(karton, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
	LoadAnimDict("anim@heists@ornate_bank@grab_cash_heels")
	TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
    FreezeEntityPosition(playerPed, true)
	DJCore.Functions.Progressbar("djchicken", "Tavukları Paketliyorsun...", 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done    
   -- 
    DeleteEntity(karton)
    DeleteEntity(tavuket)
    DeleteEntity(karton)
	DeleteEntity(tavuket)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(playerPed, false)
   TriggerServerEvent('dinjer_chicken:slaughter')
    end)
end

--paket son
--satis

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(2)
        local sleep = true
        if not notInteressted then
        if isLoggedIn and DJCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == Config.job then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["sell"].coords.x, Config.Locations["sell"].coords.y, Config.Locations["sell"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["sell"].coords.x, Config.Locations["sell"].coords.y, Config.Locations["sell"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["sell"].coords.x, Config.Locations["sell"].coords.y, Config.Locations["sell"].coords.z, true) < 7.5) then
                            DrawText3D(Config.Locations["sell"].coords.x, Config.Locations["sell"].coords.y, Config.Locations["sell"].coords.z, "~g~E~w~ - Tavukları Paketle")
                            sleep = false
                            if IsControlJustReleased(0, Keys["E"]) then
                                TavukSat()
                                notInteressted = true
                                SetTimeout(5000, ClearTimeOut)       
                            end
                    end
                end
            end
        else
            Citizen.Wait(5000)
        end
        if sleep then
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

function TavukSat()
    local ped = GetPlayerPed(-1)
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))

    prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
    SetEntityHeading(prop, GetEntityHeading(GetPlayerPed(-1)))
    LoadAnimDict('amb@medic@standing@tendtodead@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    LoadAnimDict('amb@medic@standing@tendtodead@exit')
    TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    ClearPedTasks(GetPlayerPed(-1))
    DeleteEntity(prop)
    FreezeEntityPosition(playerPed, true)
	DJCore.Functions.Progressbar("djchicken", "Tavukları Satıyorsun...", 6200, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done    
   -- 
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(playerPed, false)
    TriggerServerEvent('dinjer_chicken:packaging')
    end)
end

--satisson

 Citizen.CreateThread(function()
	
	for k,v in pairs(Config.Chickens) do
		
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite (blip, 256)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Tavuk Fabrikası')
		EndTextCommandSetBlipName(blip)
	end

end)

function ClearTimeOut()
    notInteressted = not notInteressted
end

--  function DrawText3D(x,y,z, text)
--     local onScreen,_x,_y=World3dToScreen2d(x,y,z)
--     local px,py,pz=table.unpack(GetGameplayCamCoords())
    
--     SetTextScale(0.35, 0.35)
--     SetTextFont(4)
--     SetTextProportional(1)
--     SetTextColour(255, 255, 255, 215)
--     SetTextEntry("STRING")
--     SetTextCentre(1)
--     AddTextComponentString(text)
--     DrawText(_x,_y)
--     local factor = (string.len(text)) / 370
--     DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0, 100)
-- end
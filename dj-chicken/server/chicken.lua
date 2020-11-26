DJCore = nil
TriggerEvent('DJCore:GetObject', function(obj) DJCore = obj end)
--convert by dinjer#1220
RegisterServerEvent('dinjer_chicken:chicken')
AddEventHandler('dinjer_chicken:chicken', function(itemname)
    local src = source
    local Player = DJCore.Functions.GetPlayer(src)
    local chicken = Player.Functions.GetItemByName("alive_chicken")
    if Player.Functions.AddItem("alive_chicken", math.random(1, 2)) then
        TriggerClientEvent('inventory:client:ItemBox', src, DJCore.Shared.Items["alive_chicken"], "add")
    else
        TriggerClientEvent('DJCore:Notify', src, 'Daha fazla taşıman mümkün değil..', 'error')
    end   
end)

RegisterServerEvent('dinjer_chicken:catch')
AddEventHandler('dinjer_chicken:catch', function(src) 
    local src = source
    local Player = DJCore.Functions.GetPlayer(src)
    local alive_chicken = Player.Functions.GetItemByName('alive_chicken')
    if alive_chicken ~= nil and alive_chicken.amount > 0 then
        Player.Functions.RemoveItem('alive_chicken', 1)----change this
		Player.Functions.AddItem('slaughtered_chicken', 4)-----change this
        TriggerClientEvent("inventory:client:ItemBox", source, DJCore.Shared.Items['alive_chicken'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, DJCore.Shared.Items['slaughtered_chicken'], "add")
        TriggerClientEvent('DJCore:Notify', src, "Tavuk Kesildi.")
    else
        TriggerClientEvent('DJCore:Notify', src, "Kesilecek Tavuk Yok.")
    end
end)


RegisterNetEvent("dinjer_chicken:slaughter")
AddEventHandler("dinjer_chicken:slaughter", function(item, count)
    local src = source
    local Player = DJCore.Functions.GetPlayer(src)
    local slaughtered_chicken = Player.Functions.GetItemByName("slaughtered_chicken")
        if slaughtered_chicken ~= nil and slaughtered_chicken.amount > 0 then
        Player.Functions.RemoveItem('slaughtered_chicken', 4)----change this
		Player.Functions.AddItem('packaged_chicken', 1)-----change this
        TriggerClientEvent("inventory:client:ItemBox", source, DJCore.Shared.Items['slaughtered_chicken'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, DJCore.Shared.Items['packaged_chicken'], "add")
        TriggerClientEvent('DJCore:Notify', src, "Tavuklar Paketlendi.")
    else
        TriggerClientEvent('DJCore:Notify', src, "Paketlenecek Yeterli Tavuk Yok.")
    end
end)
--convert by dinjer#1220

RegisterServerEvent("dinjer_chicken:packaging")
AddEventHandler("dinjer_chicken:packaging", function()
    local src = source
	local Player = DJCore.Functions.GetPlayer(src)
	local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "packaged_chicken" then 
                    price = price + (Config.PaketTavuk["packaged_chicken"]["price"] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("packaged_chicken", Player.PlayerData.items[k].amount, k)
                else
                    TriggerClientEvent('DJCore:Notify', src, "Satılacak Paketlenmiş Tavuk Yok.")
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "satis-parasi")
		TriggerClientEvent('DJCore:Notify', src, "Paketlediğin Tavukları sattın")
	end
end)

--convert by dinjer#1220
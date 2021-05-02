ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('bir-cuciuang:getPlayerStats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local blackmoney = xPlayer.getAccount('black_money').money
    local money = xPlayer.getMoney()
	
	cb(blackmoney, money)
		
		
	
end)



RegisterNetEvent("bir-cuciuang:successEvent")
AddEventHandler("bir-cuciuang:successEvent", function()
local xPlayer = ESX.GetPlayerFromId(source)
local blackmoney = xPlayer.getAccount('black_money').money


    xPlayer.removeMoney(Config.WashingCost)
    xPlayer.addMoney(blackmoney)
    xPlayer.removeAccountMoney('black_money', blackmoney)



end)
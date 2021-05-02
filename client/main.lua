ESX              = nil
local PlayerData = {}

local currentMoney = 0
local currentblackMoney = 0
local currentWashCost = 0


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)



local isMenuOpen = false

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(4)
	local coords = GetEntityCoords(PlayerPedId())
	local distance = GetDistanceBetweenCoords(coords, Config.MoneyWashingDealer["pos"]["x"], Config.MoneyWashingDealer["pos"]["y"], Config.MoneyWashingDealer["pos"]["z"], true) -- Die Nullen durch die Cords des Markers oder so ersetzten. Alsi da wo der Spieler E drücken kann

	if distance <= 3 then
			if isMenuOpen == false then
					ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to access the menu", thisFrame, beep, duration)
                    if IsControlJustReleased(0, 38) then
                        
                        ESX.TriggerServerCallback('bir-cuciuang:getPlayerStats', function(blackmoney, money) 
                            currentblackMoney = blackmoney
                            currentMoney = money
                            currentWashCost = Config.WashingCost
                        end)
                        Citizen.Wait(500)
                        SetDisplay(not display)
						isMenuOpen = true
					end
				else

				end

			end

	end
end)


RegisterNUICallback("exit", function(data)
    print("UI Closed")
    SetDisplay(false)
    isMenuOpen = false
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    print(currentblackMoney)
    SendNUIMessage({
        type = "ui",
        status = bool,
        currentblackMoney = currentblackMoney,
        currentWashCost = currentWashCost,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)







_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

Citizen.CreateThread(function()

    local pedPosition = Config.MoneyWashingDealer["pos"]


            _RequestModel(349680864)
            if not DoesEntityExist(pedPosition["entity"]) then
                pedPosition["entity"] = CreatePed(4, 349680864, pedPosition["x"], pedPosition["y"], pedPosition["z"] -1, pedPosition["h"])
                SetEntityAsMissionEntity(pedPosition["entity"])
                SetBlockingOfNonTemporaryEvents(pedPosition["entity"], true)
                FreezeEntityPosition(pedPosition["entity"], true)
                SetEntityInvincible(pedPosition["entity"], true)
                
		        TaskStartScenarioInPlace(pedPosition["entity"], "WORLD_HUMAN_SMOKING", 0, true);
            end
            SetModelAsNoLongerNeeded(349680864)
end)







-- CREATE BLIPS


Citizen.CreateThread(function()
        local blip = Config.MoneyWashingDealer["pos"]


        if Config.MoneyWashingDealer["showBlip"] == true then

            if blip then
                    blip = AddBlipForCoord(Config.MoneyWashingDealer["pos"]["x"], Config.MoneyWashingDealer["pos"]["y"], Config.MoneyWashingDealer["pos"]["z"])
                    SetBlipSprite(blip, 272)
                    SetBlipDisplay(blip, 4)
                    SetBlipScale(blip, 1.0)
                    SetBlipColour(blip, 2)
                    SetBlipAsShortRange(blip, true)
    
                    BeginTextCommandSetBlipName("Cuci Uang")
                    AddTextEntry("Cuci Uang", Config.MoneyWashingDealer["blipName"])
                    EndTextCommandSetBlipName(blip)
                
            end

        end

        
    
end)




RegisterNUICallback("success", function(data) 
    SetDisplay(false) 
    isMenuOpen = false

    TriggerServerEvent("bir-cuciuang:successEvent")
   

    
end)
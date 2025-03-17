local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local dragEnabled = false

if Config.Framework == 'esxnew' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'esx' then
    TriggerEvent('esx:getSharedObject', function(obj) 
        ESX = obj 
    end)
end


local isTalking = false
Citizen.CreateThread(function()
	TriggerEvent('es:setMoneyDisplay', 0.0)
	
	NetworkSetTalkerProximity(10.0)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	local data = xPlayer
	local accounts = data.accounts
	for k,v in pairs(accounts) do
		local account = v
		if account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
		end
	end

	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.grade_label, icon = job.name})
	SendNUIMessage({action = "setValue", key = "money", value = "$"..data.money})
	SendNUIMessage({action = "setValue", key = "id", value = "ID "..GetPlayerServerId(PlayerId())}) 
end)


Citizen.CreateThread(function()
	while true do
		if ESX.IsPlayerLoaded(PlayerId) then

			ESX.TriggerServerCallback('fgsal_hud:getjoblabel', function(joblabel)
				ESX.TriggerServerCallback('fgsal_hud:getjobgradelabel', function(jobgradelabel)
					ESX.TriggerServerCallback('fgsal_hud:getjobname', function(jobname)
						SendNUIMessage({action = "setValue", key = "job", value = jobgradelabel, icon = jobname})
					end)
				end)
				
			end)


			ESX.TriggerServerCallback('fgsal_hud:getCash', function(money)
				SendNUIMessage({action = "setValue", key = "money", value = "$"..money})
			end)


			id = GetPlayerServerId(PlayerId())

			SendNUIMessage({action = "setValue", key = "id", value = "ID "..id}) 


		end		


		Citizen.Wait(1000)
	end
end)


RegisterNetEvent("nearest_postal_hud")
AddEventHandler("nearest_postal_hud", function(plz_text_2)
	SendNUIMessage({action = "setValue", key = "playerid", value = "ID "..GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))).." | PLZ "..plz_text_2})
	Citizen.Wait(10)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isTalking == false then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = "setTalking", value = true})
			end
		else
			if NetworkIsPlayerTalking(PlayerId()) == false then
				isTalking = false
				SendNUIMessage({action = "setTalking", value = false})
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isTalking == false then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = "setTalking", value = true})
			end
		else
			if NetworkIsPlayerTalking(PlayerId()) == false then
				isTalking = false
				SendNUIMessage({action = "setTalking", value = false})
			end
		end
	end
end)


RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "bank" then
		SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
	elseif account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.grade_label, icon = job.name})
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)
	SendNUIMessage({action = "setValue", key = "money", value = "$"..e})	
end)

RegisterNetEvent('fgsal_hud:updateStatus')
AddEventHandler('fgsal_hud:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

RegisterNetEvent('fgsal_hud:updateWeight')
AddEventHandler('fgsal_hud:updateWeight', function(weight)
	weightprc = (weight/8000)*100
	SendNUIMessage({action = "updateWeight", weight = weightprc})
end)


Citizen.CreateThread(function()
    while true do
		if ESX.IsPlayerLoaded(PlayerId) then

			TriggerEvent(
				"esx_status:getStatus",
				"hunger",
				function(h)
					TriggerEvent(
						"esx_status:getStatus",
						"thirst",
						function(t)
							hunger = math.floor(h.getPercent())
							thirst = math.floor(t.getPercent())
									
						end
					)
				end
			)

			SendNUIMessage({hunger = hunger})
			
			SendNUIMessage({thirst = thirst})
		
		end

        Citizen.Wait(1000)
    end
end)

RegisterCommand(Config.HudsettingsCommand, function()
    dragEnabled = not dragEnabled
    SetNuiFocus(dragEnabled, dragEnabled)
    SendNUIMessage({ action = dragEnabled and 'enableDrag' or 'disableDrag' })
end, false)

RegisterCommand(Config.Hudsettingsreset, function()
    SendNUIMessage({ action = 'resetHUD' })
end, false)

RegisterNUICallback('closeUI', function(data, cb)
    dragEnabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'disableDrag' })
    cb('ok')
end)

TriggerEvent('chat:addSuggestion', '/'..Config.HudsettingsCommand, 'Verschiebt den HUD an die gewünschte Position')
TriggerEvent('chat:addSuggestion', '/'..Config.Hudsettingsreset, 'Setzte die Position von dem HUD Auf normaleinstellungen Zurück')

local rawPostalData = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
local postalList = json.decode(rawPostalData)

local closestPostal = nil
local postalBlip = nil

Citizen.CreateThread(function()
    while true do
        local xPos, yPos = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

        local closestDistance = -1
        local closestIndex = -1
        for i, postal in ipairs(postalList) do
            local distance = (xPos - postal.x) ^ 2 + (yPos - postal.y) ^ 2
            if closestDistance == -1 or distance < closestDistance then
                closestIndex = i
                closestDistance = distance
            end
        end

        if closestIndex ~= -1 then
            local distance = math.sqrt(closestDistance)
            closestPostal = {i = closestIndex, d = distance}
        end

        if postalBlip then
            local blipCoords = {x = postalBlip.p.x, y = postalBlip.p.y}
            local distance = (blipCoords.x - xPos) ^ 2 + (blipCoords.y - yPos) ^ 2
            if distance < Config.blip.distToDelete ^ 2 then
                RemoveBlip(postalBlip.hndl)
                postalBlip = nil
            end
        end

        Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        if closestPostal and not IsHudHidden() then
            local postalText = Config.text.format:format(postalList[closestPostal.i].code, closestPostal.d)
            Citizen.Wait(100)
            TriggerEvent('nearest_postal_hud', postalText)
        end
        Wait(0)
    end
end)

RegisterCommand('p', function(source, args, rawCommand)
    if #args < 1 then
        if postalBlip then
            RemoveBlip(postalBlip.hndl)
            postalBlip = nil
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = {'Postals', Config.blip.deleteText}
            })
        end
        return
    end

    local postalCode = string.upper(args[1])
    local foundPostal = nil
    for _, postal in ipairs(postalList) do
        if string.upper(postal.code) == postalCode then
            foundPostal = postal
            break
        end
    end

    if foundPostal then
        if postalBlip then
            RemoveBlip(postalBlip.hndl)
        end
        postalBlip = {hndl = AddBlipForCoord(foundPostal.x, foundPostal.y, 0.0), p = foundPostal}
        SetBlipRoute(postalBlip.hndl, true)
        SetBlipSprite(postalBlip.hndl, Config.blip.sprite)
        SetBlipColour(postalBlip.hndl, Config.blip.color)
        SetBlipRouteColour(postalBlip.hndl, Config.blip.color)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.blip.blipText:format(postalBlip.p.code))
        EndTextCommandSetBlipName(postalBlip.hndl)

        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Postals', Config.blip.drawRouteText:format(foundPostal.code)}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'Postals', Config.blip.notExistText}
        })
    end
end)

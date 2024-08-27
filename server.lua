local QBCore = exports['qb-core']:GetCoreObject()

local empActive = false
local activeBlips, activeCarsBlips = {}, {}
local active = false


CreateThread(function()
    while true do
        Wait(1500)
        local players = GetPlayers()
        local blips = {}
        for index, player in ipairs(players) do
            local playerPed = GetPlayerPed(player)
            if DoesEntityExist(playerPed) then
                local coords = GetEntityCoords(playerPed)
                blips[tostring(player)] = vector3(coords.x, coords.y, coords.z)
            end
        end
        TriggerClientEvent("racher-gps:update", -1, blips)
    end
end)


AddEventHandler("playerDropped", function(reason)
    local src = source
    removeBlip(src)
end)


RegisterNetEvent('racher-gps:addcop')
AddEventHandler('racher-gps:addcop', function(polisno, gpscolor)
    local src = source
    if empActive then 	
        TriggerClientEvent("QBCore:Notify", src, Config.Locales.gpsError, "error")
    else
        if polisno == nil then polisno = "LSPD" end
        local isim = getPlayerName(src)
        local text = '.'..polisno..' ['.. isim..']'
        addBlip(text, 38, src, 0.85, 1, gpscolor)
        TriggerClientEvent("QBCore:Notify", src, Config.Locales.gpsOpen)
        TriggerClientEvent("racher-policenotif:setGpsName", src, polisno)
        TriggerClientEvent("racher-gps:toggle", src, true, text, true, gpscolor)
        active = true
    end
end)


RegisterNetEvent('racher-gps:addmedic')
AddEventHandler('racher-gps:addmedic', function(emsNo)
    local src = source
    if empActive then 	
        TriggerClientEvent("QBCore:Notify", src, Config.Locales.gpsError, "error")
    else
        if emsNo == nil then emsNo = "EMS" end
        local isim = getPlayerName(src)
        addBlip('!'..emsNo..' ['..isim..']', 1, src, 0.7, 1)
        TriggerClientEvent("QBCore:Notify", src, Config.Locales.gpsOpen)
        TriggerClientEvent("racher-gps:toggle", src, true, text, false)
        active = true
    end
end)


RegisterNetEvent('racher-gps:closegps')
AddEventHandler('racher-gps:closegps', function(duty, id)
    local src = source
    if id then src = id end
    if duty then 
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer.PlayerData.job.onduty and (xPlayer.PlayerData.job.name == "ambulance" or xPlayer.PlayerData.job.name == "police") then
            xPlayer.Functions.SetJobDuty(false)
            TriggerClientEvent('QBCore:Notify', src, Config.Locales.jobDutyMessage, 'error', 15000)
        end
    else
        TriggerClientEvent("racher-gps:toggle", src, false)
        TriggerClientEvent("QBCore:Notify", src, Config.Locales.gpsClose, 'error')
        removeBlip(src)
        active = false
    end
end)


RegisterNetEvent('racher-gps:carBlips')
AddEventHandler('racher-gps:carBlips', function(plate, number)
    if activeCarsBlips[plate] then
        activeCarsBlips[plate].number = number
    else
        activeCarsBlips[plate] = {
            text = "",
            number = number,
            players = {},
        }
    end
    TriggerClientEvent("racher-gps:updateAllData", -1, activeBlips, activeCarsBlips)
end)


RegisterNetEvent('racher-gps:updatePlayerGps')
AddEventHandler('racher-gps:updatePlayerGps', function(updateCarBlip, plate, open, blipType, blipScale)
    local src = source
    if updateCarBlip then
        if open then
            if activeBlips[tostring(src)] then
                local xPlayer = QBCore.Functions.GetPlayer(src)
                activeCarsBlips[plate].players[tostring(src)] = xPlayer.PlayerData.charinfo.firstname.. " " ..xPlayer.PlayerData.charinfo.lastname
                activeBlips[tostring(src)].carBlip = true
                activeBlips[tostring(src)].carPlate = plate
            end	
        else
            activeCarsBlips[plate].players[tostring(src)] = nil
            if activeBlips[tostring(src)] then
                activeBlips[tostring(src)].carBlip = false
                activeBlips[tostring(src)].carPlate = ""
            end
        end
        updateCarText(plate)
        TriggerClientEvent('QBCore:Notify', src, "GPS Güncellendi!", "primary", 2000)
    end

    if activeBlips[tostring(src)] then
        activeBlips[tostring(src)].blipType = blipType
    end

    if activeBlips[tostring(src)] then
        activeBlips[tostring(src)].blipScale = blipScale
    end
    
    TriggerClientEvent("racher-gps:updateAllData", -1, activeBlips, activeCarsBlips)
end)




function getPlayerName(src)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    return xPlayer.PlayerData.charinfo.firstname.. " " ..xPlayer.PlayerData.charinfo.lastname
end


function addBlip(text, color, src, scale, type, gpscolor)
    if activeBlips[tostring(src)] then removeBlip(src) end
    if gpscolor ~= nil then 
        if gpscolor == "pd" then 
            color = 38
        elseif gpscolor == "so" then 
            color = 5
        elseif gpscolor == "hp" then 
            color = 63
        elseif gpscolor == "doj" then 
            color = 56
        elseif gpscolor == "ds" then 
            color = 81
        end
    end
    activeBlips[tostring(src)] = {
        blipText = text,
        blipColor = color,
        carBlip = false,
        carPlate = "",
        blipScale = scale,
        blipType = type
    }
    TriggerClientEvent("racher-gps:updateAllData", -1, activeBlips, activeCarsBlips)
end


function removeBlip(src)
    if activeBlips[tostring(src)] then
        activeBlips[tostring(src)] = nil
        for plate, data in pairs(activeCarsBlips) do
            for pSrc, players in pairs(data.players) do
                if pSrc == tostring(src) then
                    activeCarsBlips[plate].players[tostring(src)] = nil
                    updateCarText(plate)
                    break
                end
            end
        end
        TriggerClientEvent("racher-gps:removePlayerGps", -1, src, activeBlips, activeCarsBlips)
    end
end


function updateCarText(plate)
    local first = true
    if next(activeCarsBlips[plate].players) then
        for x, playerName in pairs(activeCarsBlips[plate].players) do
            if first then
                first = false
                text = "."..activeCarsBlips[plate].number.." ["..playerName
            else
                text = text .. ","..playerName
            end
        end
        text = text.."]"
    else
        text = ""
    end
    activeCarsBlips[plate].text = text
end


QBCore.Functions.CreateUseableItem('leo_gps', function(source, item)
    if not active then
        TriggerClientEvent("racher-gps:open", source)
    else
        TriggerClientEvent("racher-gps:close", source)
    end
end)

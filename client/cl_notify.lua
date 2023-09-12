-- Current city
local currentZone = ""

function getZoneData(hash)
	if hash ~= false then
		local sd = Config.ZoneData[hash]
		if sd then
			return sd.texture
		else
			print('No data for:', hash)
			return nil
		end
	else
		return nil
	end
end

-- Main thread which deals with zone notifications
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)

        -- Get the current player zone
        local x, y, z = table.unpack(GetEntityCoords(player))		
		local zone = nil
	
		local tempstate = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 0)
		if tempstate then
			zone = tempstate
		end

		local tempwritten = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 13)
		if tempwritten then
			zone = tempwritten
		end

		local tempprint = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 12)
		if tempprint then
			zone = tempprint
		end

		local tempdistrict = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 10)
		if tempdistrict then
			zone = tempdistrict
		end

		local temptown = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 1)
		if temptown then
			zone = temptown
        end

        -- Show notification with rNotify if the player is visting the zone first time
        if currentZone ~= zone then
            -- get current zone for texture
            local zoneTexture = getZoneData(zone)
            TriggerEvent('rNotify:NotifyTop', Config.NotifyText, zoneTexture, 4000)
        end
		
    end
end)
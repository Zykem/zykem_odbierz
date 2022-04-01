ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function zykemLog(eventname,wiecejinfo,idgracza)
	local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false


  for k,v in pairs(GetPlayerIdentifiers(idgracza))do
        
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steamid = v
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        license = v
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        xbl  = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        ip = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        discord = v
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        liveid = v
      end
    
	  
	end
	local embed = {
        {
            ["color"] = 16753920,
            ["title"] = "**zykem_odbierz**",
            ["description"] = 'Gracz wlasnie uzyl `'..eventname..'`\nSteamID: **'..steamid..'**\nLicencja: **'..license..'**\nIP: **'..ip..'\n**ID Serwerowe:**' .. idgracza .. '\n**Nick Gracza:** '..GetPlayerName(idgracza)..'\n\n**Wiecej info:**'..wiecejinfo..'**',
            ["footer"] = {
                ["text"] = 'zykem_odbierz Logs',
            },
        }
    }
	PerformHttpRequest(cfg.Webhook, function(err, text, headers) end, 'POST', json.encode({username = 'zykem_odbierz', embeds = embed}), { ['Content-Type'] = 'application/json' })

end

RegisterCommand("odbierz", function(source)
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
		'SELECT steam_name, expires as timestamp FROM zykem_odbierz WHERE steam_name = @steam_name',
		{ 
			['@steam_name'] = xPlayer.getName()
		},
		function(result)
			
            if result[1] ~= nil then

                local time = tostring(result[1].timestamp)
                local datafull = os.date('%Y-%m-%d %H:%M:%S', time)
                TriggerClientEvent('z-odbierz:notify', source, 'Juz odebrales Zestaw. Kolejny mozesz odebrac: ' .. os.date('%Y-%m-%d %H:%M:%S', time), 2000)

            else
              
              local dataxD = {

                rok = round(os.date('%Y'),0),
              miesiac = round(os.date('%m'),0),
              dzien = round(os.date('%d')+1,0),
              godzina = round(os.date('%H'),0),
              minuta = round(os.date('%M'),0),
              sekunda = round(os.date('%S'),0)
        
            }
        
          local cData = {year = dataxD.rok, month = dataxD.miesiac, day = dataxD.dzien, hour = dataxD.godzina, min = dataxD.minuta, sec = dataxD.sekunda}
            local final_data = os.time(cData)
            

            items = {}
          for k, v in pairs(cfg.Itemy.list) do

              if v.item or v.weapon then
                  if v.amount then
                      
                      table.insert(items, 
                  {
                      item = v.item,
                      amount = v.amount,
                      weapon = v.weapon,
                      
                  })
              
                  else
                      table.insert(items, 
                  {

                      item = v.item,
                      amount = 1,
                      weapon = v.weapon

                  })
                  end
              end

          end
          for k,v in pairs(items) do

            if v.weapon then

              if cfg.weaponsync == true then

                xPlayer.addInventoryItem(v.weapon, v.amount)

              else

                xPlayer.addWeapon('weapon_'..v.weapon, 250)

              end

            end
            xPlayer.addInventoryItem(v.item, v.amount)  
            

        end
        if cfg.Logs == true then

          zykemLog('/odbierz', 'Gracz otrzymal wlasnie odebral Starter-Pack', source)

        end

          TriggerClientEvent('z-odbierz:notify', source, 'Odebrales Zestaw Startowy!', 2000)
          MySQL.Sync.execute('INSERT INTO zykem_odbierz (steam_name, expires, xd) VALUES (@steamname, @time, @xd)',
            {
                ['@steamname'] = xPlayer.getName(),
                ['@time'] = final_data,
                ['@xd'] = 'zykem_odbierz'
        
            }, function(result)
            
            end)

            end

		end)

end)


function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
      local mult = 10^numDecimalPlaces
      return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
  end

RegisterServerEvent('zykem_odbierz:odbierz')
AddEventHandler('zykem_odbierz:odbierz', function(item, amount)

    print(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    

end)


RegisterServerEvent('zykem_odbierz:deleteExpired')
AddEventHandler('zykem_odbierz:deleteExpired', function(steam_name, xd)
	MySQL.Async.execute('DELETE FROM zykem_odbierz WHERE xd = @xd AND steam_name = @steam_name', 
	{
		['@xd'] = 'zykem_odbierz',
		['@steam_name'] = steam_name
	}, function(rowsChanged)
		print("Usunieto jednego  Usera z listy odbierz")
	end)
end)

function checkTime(d, h, m)
	print("[zykem_odbierz] -> Sprawdzam czas")

	MySQL.Async.fetchAll('SELECT steam_name, xd, expires as timestamp FROM zykem_odbierz WHERE xd = @xd', 
		{
			['@xd'] = 'zykem_odbierz'
		}, 
		function(result)
			local time_now = os.time()
			for i=1, #result, 1 do
				local dostepTime = result[i].timestamp
				if dostepTime <= time_now then
					TriggerEvent('zykem_odbierz:deleteExpired', result[i].steam_name, result[i].xd)
				end
			end
		end
	)
end

ESX.RegisterServerCallback('zykem_odbierz:checkUser',function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	
	MySQL.Async.fetchAll(
		'SELECT steam_name, expires as timestamp FROM zykem_odbierz WHERE steam_name = @steam_name',
		{ 
			['@steam_name'] = xPlayer.getName()
		},
		function(result)
			
            if result[1] ~= nil then

                local time = tostring(result[1].timestamp)
                cb(os.date('%Y-%m-%d %H:%M:%S', time))

            else

                cb(nil)

            end

		end
	)
end)

  TriggerEvent('cron:runAt', 02, 0, checkTime)
TriggerEvent('cron:runAt', 04, 0, checkTime)
TriggerEvent('cron:runAt', 12, 0, checkTime)
TriggerEvent('cron:runAt', 14, 0, checkTime)
TriggerEvent('cron:runAt', 16, 0, checkTime)
TriggerEvent('cron:runAt', 18, 0, checkTime)
TriggerEvent('cron:runAt', 20, 0, checkTime)
TriggerEvent('cron:runAt', 22, 0, checkTime)
TriggerEvent('cron:runAt', 24, 0, checkTime)
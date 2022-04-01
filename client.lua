ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


RegisterNetEvent('z-odbierz:notify')
AddEventHandler('z-odbierz:notify', function(text, interval)

    ESX.ShowNotification(text, interval)

end)
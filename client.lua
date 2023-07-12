-- Variables


local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("ns-pdpouch:client:UsePolicePouch", function(ItemData)
    RequestAnimDict('mp_arresting')
      while (not HasAnimDictLoaded('mp_arresting')) do
      Wait(0)
      end
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    TaskPlayAnim(PlayerPedId(), "mp_arresting" ,"a_uncuff" ,8.0, -8.0, -1, 1, 0, false, false, false )
    local PedCoords = GetEntityCoords(PlayerPedId())
    pouchbag = CreateObject(GetHashKey('h4_prop_h4_pouch_01a'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
    AttachEntityToEntity(pouchbag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.1, 0.1, 0.0, 0.0, 10.0, 90.0, false, false, false, false, 2, true)
    QBCore.Functions.Notify("Pouch is being opened...", "primary")
    if lib.progressCircle({
        duration = 2000,
        position = 'bottom',
        label = 'Pouch is being opened',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = true
        },
    }) then 
        local pouchoptions = {}
        for k, v in pairs(Config.PouchItems) do
            pouchoptions[#pouchoptions+1] = {
                title = v.label,
                description = '',
                icon = 'fas fa-gun',
                image = "nui://ox_inventory/web/images/"..QBCore.Shared.Items[v.name].image,
                event = 'takepouchitems',
                args = {
                    itemtype = 'gsrtestkit',
                    senData = pouchData,
                }
            }
        end
        
        lib.registerContext({
            id = 'policepouch_menu',
            title = 'Police Pouch',
            options = pouchoptions
        })
            lib.showContext('policepouch_menu')
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Wait(3500)
        DeleteEntity(pouchbag)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('takepouchitems', function(data)
        local input = lib.inputDialog("How many "..QBCore.Shared.Items[data.itemtype].label.. " do you want to take?", {
            { type = "slider", label = "Amount", default = 1, max = 5 }
        })
        if input[1] then
            TriggerServerEvent("ns-pdpouch:server:RemovePouchStuff",data.itemtype, input[1])
        end
end)

RegisterNetEvent('refillpouchclient', function()
    local ped = PlayerPedId()
    if lib.progressBar({
        duration = 15000,
        label = 'Refilling pouch',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = true
        },
        anim = {
            dict = 'random@shop_tattoo',
            clip = '_idle_a'
        },
    })  
    then 
         TriggerServerEvent('refillpouch')
    else
        QBCore.Functions.Notify('Cancelled', "error")
    end
end)

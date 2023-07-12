
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ns-pdpouch:server:RemovePouchStuff', function(itemtype, pouchitemamount)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
      Player.Functions.AddItem(itemtype, pouchitemamount)
end)

QBCore.Functions.CreateUseableItem("policepouch", function(source, item)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if Player.PlayerData.job.name == 'police' then
     TriggerClientEvent("ns-pdpouch:client:UsePolicePouch", src, item)
  else
    TriggerClientEvent('QBCore:Notify', src, 'Only a Police Officer can access this', 'error')
  end
end)

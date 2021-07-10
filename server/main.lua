inventari = { 
"policija"
	
}

podaci = {}
local ocitano = ""

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then


	ocitano = LoadResourceFile(GetCurrentResourceName(), "podaci.json") or ""
			if ocitano ~= "" then
		podaci = json.decode(ocitano)
		else
		podaci = {}
		end

		for k,v in pairs(inventari) do
			if not podaci[v] then
			podaci[v] = {}
			end
		end
	end
end)



AddEventHandler('esxbalkan_addoninventory:staviitem', function(ime,label,kolicina,organizacija)
	if #podaci[organizacija] > 0 then
	for k,v in pairs(podaci[organizacija]) do
		if v.ime == ime then
				v.kolicina=v.kolicina + kolicina
				break
		else
			table.insert(podaci[organizacija], {
				ime=ime,
				label = label,
				kolicina= kolicina
			})
			break
		end
	end
else
	table.insert(podaci[organizacija], {
		ime=ime,
		label = label,
		kolicina= kolicina
	})
end
end)

AddEventHandler('esxbalkan_addoninventory:izvadiitem', function(ime,kolicina,organizacija)
	for k,v in pairs(podaci[organizacija]) do
		if v.ime == ime then
			if kolicina == v.kolicina then
				table.remove(podaci[organizacija],k)
				break
			else
				v.kolicina = v.kolicina - kolicina
			end
		end
	end
end)


AddEventHandler('esxbalkan_addoninventory:fetchajsef', function(organizacija,cb)
cb(podaci[organizacija])
print(podaci[organizacija])
end)



RegisterNetEvent('esxbalkan_addoninventory:sacuvaj')
AddEventHandler('esxbalkan_addoninventory:sacuvaj', function()
	SaveResourceFile(GetCurrentResourceName(), "podaci.json", json.encode(podaci), -1)
end)




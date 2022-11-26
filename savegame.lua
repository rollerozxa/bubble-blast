
-- savegame.lua: Savegame functionality

savegame = {
	data = {}
}

function savegame.load()
	local savejson = love.filesystem.read("savedata.json")
	if savejson ~= nil then
		savegame.data = json.decode(savejson)
	end
end

function savegame.save()
	love.filesystem.write("savedata.json", json.encode(savegame.data))
end

function savegame.get(key)
	return savegame.data[key]
end

function savegame.set(key, value)
	savegame.data[key] = value
	savegame.save()
end

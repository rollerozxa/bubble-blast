
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

-- Changes the value of the savegame key (if does not exist, it will set key to value).
function savegame.change(key, value)
	savegame.set(key, (savegame.get(key) or 0) + value)
end

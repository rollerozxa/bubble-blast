json = require("misc.json")

for pack = 1,100 do
	local packdata = json.decode(love.filesystem.read("kwav_cutter/levels/"..pack..".json"))
	love.filesystem.createDirectory("levelpacks/"..pack)

	local lvlnum = 1
	for _,leveldata in pairs(packdata.levels) do
		local level = {}
		level.presses = leveldata.touchmax
		level.bubbles = {}

		local item = 0
		for _,bubble in pairs(leveldata.items) do
			if bubble ~= 0 then
				local x = (item % 5) + 1
				local y = (item - (item % 5)) / 5 + 1
				table.insert(level.bubbles, {
					x = x,
					y = y,
					state = bubble
				})
			end

			item = item + 1
		end

		love.filesystem.write("levelpacks/"..pack.."/"..lvlnum..".json", json.encode(level))

		lvlnum = lvlnum + 1
	end
end

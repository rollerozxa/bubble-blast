
-- Utility script to convert original Bubble Blast levels into the format used by LÖVE Blast.

json = require("misc.json")
love.filesystem.createDirectory("levelpacks/")

for pack = 1,100 do
	local packdata = json.decode(love.filesystem.read("kwav_cutter/levels/"..pack..".json"))

	local lvlnum = 1
	local levels = {}

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
					st = bubble
				})
			end

			item = item + 1
		end

		table.insert(levels, level)

		lvlnum = lvlnum + 1
	end

	love.filesystem.write("levelpacks/"..pack..".json", json.encode({ levels = levels }))
end

love.event.quit()

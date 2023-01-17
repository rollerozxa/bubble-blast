
-- debug.lua: Debug utilities

return {
	grid = {
		enabled = false,
		keybind = 'g',
		draw = function()
			local cellSize = scaledY(32)

			for x = cellSize, game.resolution.x, cellSize do
				love.graphics.line(x, 0, x, game.resolution.y)
			end

			for y = cellSize, game.resolution.y, cellSize do
				love.graphics.line(0, y, game.resolution.x, y)
			end

			love.graphics.print("Debug Grid On", 5, 460)
		end
	},
	info = {
		enabled = false,
		keybind = 'f',
		draw = function()
			love.graphics.print("FPS: "..love.timer.getFPS()..", Running at "..game.resolution.x.."x"..game.resolution.y, 5, 10)
		end
	},
	test = {
		enabled = false,
		keybind = 't',
		draw = function()
			love.graphics.print("blarg: "..tostring(oldmousedown))
		end
	}
}

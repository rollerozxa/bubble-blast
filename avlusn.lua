
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

	mouse = {
		enabled = false,
		keybind = 'm',
		draw = function()
			love.graphics.print("Debug Mouse Coll.", 5, 460)

			love.graphics.setColor(0.3, 0.3, 0.9)
			love.graphics.rectangle('fill', love.mouse.getX()-16, love.mouse.getY()-16, 32, 32)
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
	},

	presses = {
		enabled = false,
		keybind = 'p',
		draw = function()
			love.graphics.print(table.concat(presses, ", "))
		end
	},
}

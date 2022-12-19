
-- debug.lua: Debug utilities

return {
	grid = {
		enabled = false,
		keybind = 'g',
		draw = function()
			for x = 0,40 do
				for y = 0,40 do
					love.graphics.draw(assets.debug_grid, scaledX(x*32), scaledY(y*32), 0, scaledX(), scaledY())
				end
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


-- mainmenu.lua: Main menu scene

scenes.mainmenu = {}

local gui = {
	playbtn = {
		type = "button",
		x = 96, y = 8*32,
		size = { x = 160, y = 32 },
		label = S("Play"),
		on_click = function()
			switchState("selectpack")
		end
	},

	helpbtn = {
		type = "button",
		x = 96, y = 10*32,
		size = { x = 160, y = 32 },
		label = S("How to play"),
		on_click = function()
			switchState("help")
		end
	},

	settingsbtn = {
		type = "button",
		x = 96, y = 12*32,
		size = { x = 160, y = 32 },
		label = S("Settings"),
		on_click = function()
			switchState("settings")
		end
	}
}

function scenes.mainmenu.update()
	gtk.update(gui)
end

function scenes.mainmenu.draw()
	drawBG(64/255, 148/255, 79/255)

	gtk.draw(gui)

	love.graphics.setFont(fonts.sans.bigger)
	love.graphics.setColor(0,0,0)
	for x = -4, 4, 1 do
		for y = -4, 4, 1 do
			love.graphics.print("Bubble Blast", scaledX(35+x), scaledY(53+y), 0, scaledX(), scaledY())
		end
	end
	love.graphics.setColor(1,1,1)
	love.graphics.print("Bubble Blast", scaledX(35), scaledY(53), 0, scaledX(), scaledY())
end

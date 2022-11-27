
-- mainmenu.lua: Main menu scene

scenes.mainmenu = {}

local gui = {
	playbtn = {
		type = "button",
		x = 96,
		y = 288,
		size = {
			x = 160,
			y = 32
		},
		label = "Play",
		on_click = function()
			switchState("selectlevel")
		end
	},
	settingsbtn = {
		type = "button",
		x = 96,
		y = 352,
		size = {
			x = 160,
			y = 32
		},
		label = "Settings",
		on_click = function()
			-- dummy
		end
	}
}

function scenes.mainmenu.update()
	gtk.update(gui)
end

function scenes.mainmenu.draw()
	love.graphics.setBackgroundColor(64/255, 148/255, 79/255)

	gtk.draw(gui)

	love.graphics.setFont(fonts.sans.bigger)
	love.graphics.print("Bubble Blast", scaledX(35), scaledY(53), 0, scaledX(), scaledY())
end

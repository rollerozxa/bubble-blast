
scenes.settings = {}

local gui = {
	back = {
		type = "button",
		x = 0, y = 0,
		size = { x = 82, y = 32 },
		label = S("Back"),
		on_click = function()
			switchState("mainmenu")
		end,
		keybind = "escape"
	},

	screen_align_lbl = {
		type = "label",
		x = 32, y = 64,
		size = { x = 82, y = 32 },
		label = S("Game screen align:")
	},

	screen_align_top = {
		type = "button",
		x = 32*1, y = 32*3,
		size = { x = 32*2.5, y = 32 },
		label = S("Top"),
		on_click = function()
			switchScreenAlign("top")
		end
	},
	screen_align_center = {
		type = "button",
		x = 32*4, y = 32*3,
		size = { x = 32*2.5, y = 32 },
		label = S("Center"),
		on_click = function()
			switchScreenAlign("center")
		end
	},
	screen_align_bottom = {
		type = "button",
		x = 32*7, y = 32*3,
		size = { x = 32*2.5, y = 32 },
		label = S("Bottom"),
		on_click = function()
			switchScreenAlign("bottom")
		end
	},

}


function scenes.settings.init()

end

function scenes.settings.update()
	gtk.update(gui)
end

function scenes.settings.draw()
	drawBG(64/255, 148/255, 79/255)

	gtk.draw(gui)
end


scenes.selectpack = {}

local gui = {
	back_button = {
		type = "tex_button",
		x = 0, y = 0,
		size = { x = 64, y = 32 },
		scale = 0.25,
		texture = "back_btn",
		on_click = function()
			switchState("mainmenu")
		end,
		keybind = "escape"
	},
}

for i = 1, 5, 1 do
	gui["levelpack"..i] = {
		type = "button",
		x = 64, y = 64+(i*64),
		size = { x = 7*32, y = 32 },
		label = "Level Pack "..i,
		on_click = function()
			if game.levelpacksUnlocked >= i then
				game.levelpack = i
				switchState('selectlevel')
			end
		end,
		on_draw = function()
			if game.levelpacksUnlocked < i then
				-- Override label, slap a fucking lock on it
				love.graphics.draw(assets.lock, scaledX(5*32), scaledY(64+(i*64)), 0, scaledX(0.25), scaledY(0.25))

				return true
			end
		end
	}
end

function scenes.selectpack.init()

end

function scenes.selectpack.update()
	gtk.update(gui)
end

function scenes.selectpack.draw()
	drawBG(64/255, 120/255, 161/255)

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.print(S("Select Level Pack"), scaledX(72), scaledY(69), 0, scaledX(), scaledY())
	love.graphics.setFont(fonts.sans.small)

	gtk.draw(gui)
end

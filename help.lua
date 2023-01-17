
scenes.help = {}

local gui = {
	alrightbtn = {
		type = "button",
		x = 96, y = 13*32,
		size = { x = 160, y = 32 },
		label = S("Alright..."),
		on_click = function()
			switchState("mainmenu")
		end,
		keybind = "escape"
	}
}

function scenes.help.init()

end

function scenes.help.update()
	gtk.update(gui)
end

function scenes.help.draw()
	drawBG(64/255, 79/255, 148/255)

	love.graphics.setFont(fonts.sans.bigger)
	love.graphics.print("~How to play~", scaledX(20), scaledY(16), 0, scaledX(), scaledY())

	love.graphics.setFont(fonts.sans.small)
	love.graphics.print("You play the game by pressing\nthe bubbles. When bubbles pop,\nthey cause a chain reaction.",
		scaledX(10), scaledY(2.5*32), 0, scaledX(), scaledY())

	love.graphics.print("There are 4 levels of bubbles:",
		scaledX(10), scaledY(5.5*32), 0, scaledX(), scaledY())

	for i = 1, 4, 1 do
		love.graphics.draw(assets.bubble[i], scaledX(32+(i-1)*64), scaledY(7*32), 0, scaledX(0.25), scaledY(0.25))
		love.graphics.draw(assets.bubble_eyes, scaledX(32+(i-1)*64), scaledY(7*32), 0, scaledX(0.25), scaledY(0.25))

		love.graphics.draw(assets.arrow_right, scaledX(64+(i-1)*64), scaledY(7*32), 0, scaledX(0.25), scaledY(0.25))
	end
	love.graphics.print("*pop*", scaledX(9*32+8), scaledY(7*32-8), math.pi/4, scaledX(), scaledY())

	love.graphics.print("Each level requires one press\nor particle, and a red bubble\nwill pop creating particles\nin each direction.",
		scaledX(10), scaledY(9*32), 0, scaledX(), scaledY())

	gtk.draw(gui)
end

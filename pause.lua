
overlays.pause = {}

local gui = {
	resumebtn = {
		type = "button",
		x = 96, y = 6*32,
		size = { x = 160, y = 32 },
		label = S("Resume"),
		on_click = function()
			switchOverlay(false)
		end,
		keybind = 'escape'
	},
	exitbtn = {
		type = "button",
		x = 96, y = 8*32,
		size = { x = 160, y = 32 },
		label = S("Exit"),
		on_click = function()
			switchOverlay(false)
			switchState('selectlevel')
		end
	}
}

function overlays.pause.init()

end

function overlays.pause.update()
	gtk.update(gui)
end

function overlays.pause.draw()
	love.graphics.setColor(0.1,0.1,0.1,0.9)
	love.graphics.rectangle('fill', scaledX(32), scaledY(32), scaledX(9*32), scaledY(13*32))

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.mediumbig)
	drawCenteredText(scaledX(4), scaledY(48), game.resolution.x, scaledY(64), S("Game paused"))

	gtk.draw(gui)
end
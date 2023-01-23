
overlays.lose = {}

local gui = {
	restartbtn = {
		type = "button",
		x = 96, y = 8*32,
		size = { x = 160, y = 32 },
		label = S("Retry"),
		on_click = function()
			switchOverlay(false)
			scenes.game.init()
		end
	},

	exitbtn = {
		type = "button",
		x = 96, y = 10*32,
		size = { x = 160, y = 32 },
		label = S("Exit"),
		on_click = function()
			switchOverlay(false)
			switchState('selectlevel')
		end
	}
}

function overlays.lose.init()
	sounds.lose:clone():play()
end

function overlays.lose.update()
	gtk.update(gui, true)
end

function overlays.lose.draw()
	love.graphics.setColor(0.1,0.1,0.1,0.9)
	love.graphics.rectangle('fill', scaledX(32), scaledY(32), scaledX(9*32), scaledY(13*32))

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.mediumbig)
	drawCenteredText(scaledX(4), scaledY(64), game.resolution.x, scaledY(64), S("Game over..."))

	gtk.draw(gui, true)
end

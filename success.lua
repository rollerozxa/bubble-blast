
overlays.success = {}

local gui = {
	back = {
		type = "button",
		x = 1.5*32, y = 12*32,
		size = { x = 2.5*32, y = 32 },
		label = "Back",
		on_click = function()

		end
	},

	nextlevel = {
		type = "button",
		x = 5*32, y = 12*32,
		size = { x = 4.5*32, y = 32 },
		label = "Next level",
		on_click = function()

		end
	},
}

function overlays.success.init()

end

function overlays.success.update()
	gtk.update(gui)
end

function overlays.success.draw()
	love.graphics.setColor(0.1,0.1,0.1,0.9)
	love.graphics.rectangle('fill', scaledX(32), scaledY(32), scaledX(9*32), scaledY(13*32))

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.mediumbig)
	drawCenteredText(scaledX(4), scaledY(48), game.resolution.x, scaledY(64), "Level Complete!")

	local texts = {
		"Level: 14",
		"Score: 483",
		"Touches: 1 / 1"
	}

	love.graphics.setFont(fonts.sans.medium)
	for i = 1, 3, 1 do
		love.graphics.print(texts[i], scaledX(64), scaledY(3*32+(i*48)), 0, scaledX(), scaledY())
	end




	gtk.draw(gui)
end


scenes.mainmenu = {}

gui = {
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
	for id, el in pairs(gui) do
		if MouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and MouseClick() then
			el.on_click()
		end
	end
end

function scenes.mainmenu.draw()
	love.graphics.setBackgroundColor(64/255, 148/255, 79/255)

	for id, el in pairs(gui) do
		if MouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) then
			love.graphics.setColor(0,0,0.1)
		else
			love.graphics.setColor(0.1,0.1,0.1)
		end

		love.graphics.rectangle("fill", ScaledX(el.x), ScaledY(el.y), ScaledX(el.size.x), ScaledY(el.size.y))
		love.graphics.setColor(1,1,1)
		love.graphics.setFont(fonts.sans.medium)
		drawCenteredText(ScaledX(el.x), ScaledY(el.y+2), ScaledX(el.size.x), ScaledY(el.size.y), el.label)
	end

	love.graphics.setFont(fonts.sans.bigger)
	love.graphics.print("Bubble Blast", ScaledX(35), ScaledY(53), 0, ScaledX(), ScaledY())
end


scenes.mainmenu = {}

function scenes.mainmenu.update()
	if CheckMouseCollisionScaled(96, 320, 160, 32) then
		game.state = "selectlevel"
		game.newlyState = true
	end
end

function scenes.mainmenu.draw()
	love.graphics.draw(assets.btn_play, ScaledX(96), ScaledY(320), 0, ScaledX(), ScaledY())

	love.graphics.setFont(assets.fonts.defaultBig)
	love.graphics.print("Bubble Blast !", ScaledX(35), ScaledY(53), 0, ScaledX(), ScaledY())
end

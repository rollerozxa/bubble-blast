
scenes.mainmenu = {}

function scenes.mainmenu.update()
	if CheckMouseCollision(96, 320, 160, 32) then
		game.state = 2
		game.newlyState = true
	end
end

function scenes.mainmenu.draw()
	love.graphics.draw(assets.btn_play, 96, 320)

	love.graphics.setFont(assets.fonts.defaultBig)
	love.graphics.print("Bubble Blast !", 35, 53, 0, 1)
end

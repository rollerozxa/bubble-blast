
overlays.success = {}

local gui = {
	back = {
		type = "button",
		x = 1.5*32, y = 12*32,
		size = { x = 2.5*32, y = 32 },
		label = S("Back"),
		on_click = function()
			switchOverlay(false)
			switchState("selectlevel")
		end
	},

	nextlevel = {
		type = "button",
		x = 5*32, y = 12*32,
		size = { x = 4.5*32, y = 32 },
		label = S("Next level"),
		on_click = function()
			if game.level == 100 then
				game.level = 1
				game.levelpack = game.levelpack + 1
				scenes.selectlevel.page = 1
			else
				game.level = game.level + 1
			end

			switchOverlay(false)
			switchState("game")
		end,
		--is_visible = function()
		--	return game.level ~= 100 and game.levelpack ~= 5
		--end
	}
}

function overlays.success.init()
	sounds.success:clone():play()

	if game.level == game.levelsUnlocked or game.level == 100 then
		if game.level == 100 then
			game.levelsUnlocked = 1
			game.levelpacksUnlocked = game.levelpacksUnlocked + 1

			savegame.set('levelpacksUnlocked', game.levelpacksUnlocked)
		else
			game.levelsUnlocked = game.levelsUnlocked + 1
		end

		savegame.set('levelsUnlocked', game.levelsUnlocked)
	end
end

function overlays.success.update()
	gtk.update(gui, true)
end

function overlays.success.draw()
	love.graphics.setColor(0.1,0.1,0.1,0.9)
	love.graphics.rectangle('fill', scaledX(32), scaledY(32), scaledX(9*32), scaledY(13*32))

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.mediumbig)
	drawCenteredText(scaledX(4), scaledY(64), game.resolution.x, scaledY(64), S("Level Complete!"))

	local texts = {
		S("Level: %s", game.level),
		--S("Score: %s", 'N/A'),
		S("Touches: %s / %s", (game.max_presses - game.presses), game.max_presses)
	}

	love.graphics.setFont(fonts.sans.medium)
	for i = 1, #texts, 1 do
		love.graphics.print(texts[i], scaledX(64), scaledY(4*32+(i*48)), 0, scaledX(), scaledY())
	end

	gtk.draw(gui, true)
end

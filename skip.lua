
overlays.skip = {}

local gui = {
	skipbtn = {
		type = "button",
		x = 96, y = 10*32,
		size = { x = 160, y = 32 },
		label = S("Yes, skip!"),
		on_click = function()
			savegame.set('skip'..game.levelpack..'-'..game.level, true)
			savegame.set('timesLost', 0)

			if game.level == 100 then
				game.level = 1
				game.levelpack = game.levelpack + 1
				game.levelsUnlocked = 1
				game.levelpacksUnlocked = game.levelpacksUnlocked + 1
				scenes.selectlevel.page = 1

				savegame.set('levelpacksUnlocked', game.levelpacksUnlocked)
			else
				game.levelsUnlocked = game.levelsUnlocked + 1
				game.level = game.level + 1
			end

			savegame.set('levelsUnlocked', game.levelsUnlocked)

			switchOverlay(false)
			switchState("game")
		end
	},

	restartbtn = {
		type = "button",
		x = 96, y = 12*32,
		size = { x = 160, y = 32 },
		label = S("Nah, retry"),
		on_click = function()
			switchOverlay(false)
			scenes.game.init()
			savegame.set('timesLost', 0)
		end
	}
}

function overlays.skip.init()
	sounds.lose:clone():play()

	savegame.set('timesLost', (savegame.get("timesLost") or 0)+1)
end

function overlays.skip.update()
	gtk.update(gui, true)
end

local text = {
	"It looks like you're",
	"stuck. Would you like",
	"to skip this level?",
	"You can go back to this",
	"level anytime."}

function overlays.skip.draw()
	love.graphics.setColor(0.1,0.1,0.1,0.9)
	love.graphics.rectangle('fill', scaledX(32), scaledY(32), scaledX(9*32), scaledY(13*32))

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.mediumbig)
	drawCenteredText(scaledX(4), scaledY(64), game.resolution.x, scaledY(64), S("Game over..."))

	love.graphics.setFont(fonts.sans.small)
	local y = 32*4
	for _,t in pairs(text) do
		drawCenteredText(0, scaledY(y), game.resolution.x, scaledY(32), t)
		y = y + 32
	end

	gtk.draw(gui, true)
end

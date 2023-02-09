
overlays.final = {}

local gui = {
	back = {
		type = "button",
		x = 96, y = 12*32,
		size = { x = 160, y = 32 },
		label = S("yay ^-^"),
		on_click = function()
			switchOverlay(false)
			switchState("selectlevel")
		end
	},
}

function overlays.final.init()
	sounds.success:clone():play()

	savegame.set('skip'..game.levelpack..'-'..game.level, nil)

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

	savegame.set('timesLost', 0)
end

function overlays.final.update()
	gtk.update(gui, true)
end

local text = {
	"Congratulations, you've",
	"completed all the levels",
	"currently in the game!",
	"",
	"Stay tuned for new updates",
	"with more levels..."}

function overlays.final.draw()
	love.graphics.setColor(0.1,0.1,0.1,0.9)
	love.graphics.rectangle('fill', scaledX(32), scaledY(32), scaledX(9*32), scaledY(13*32))

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.mediumbig)
	drawCenteredText(scaledX(4), scaledY(64), game.resolution.x, scaledY(64), S("Level Complete!"))

	love.graphics.setFont(fonts.sans.small)
	local y = 32*4
	for _,t in pairs(text) do
		drawCenteredText(0, scaledY(y), game.resolution.x, scaledY(32), t)
		y = y + 32
	end

	gtk.draw(gui, true)
end

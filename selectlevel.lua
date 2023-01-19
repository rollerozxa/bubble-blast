
-- selectlevel.lua: Select level scene

scenes.selectlevel = {}

scenes.selectlevel.page = 1

local gui = {
	back_button = {
		type = "tex_button",
		x = 0, y = 0,
		size = { x = 64, y = 32 },
		scale = 0.25,
		texture = "back_btn",
		on_click = function()
			switchState("mainmenu")
		end,
		keybind = "escape"
	},

	prev_button = {
		type = "tex_button",
		x = 32, y = 64,
		size = { x = 32, y = 32 },
		scale = 0.25,
		texture = "arrow_left",
		on_click = function()
			scenes.selectlevel.page = scenes.selectlevel.page - 1
		end,
		is_visible = function()
			return scenes.selectlevel.page ~= 1
		end
	},
	next_button = {
		type = "tex_button",
		x = 288, y = 64,
		size = { x = 32, y = 32 },
		scale = 0.25,
		texture = "arrow_right",
		on_click = function()
			scenes.selectlevel.page = scenes.selectlevel.page + 1
		end,
		is_visible = function()
			return scenes.selectlevel.page ~= 4
		end
	},
}

-- Checks if player can play level, depending on levels unlocked
-- and levelpacks unlocked.
function canPlay(levelnum)
	return (levelnum <= game.levelsUnlocked)
		or (game.levelpack < game.levelpacksUnlocked)
end

function scenes.selectlevel.update()
	gtk.update(gui)

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		if mouseCollisionScaled(x * 64 - 32, 128 + y * 64, 32, 32) and mouseClick() and canPlay(levelnum) then
			game.level = levelnum
			switchState("game")
			sounds.click:clone():play()
		end
	end
end

function scenes.selectlevel.draw()
	drawBG(64/255, 120/255, 161/255)

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.print(S("Page: %s", scenes.selectlevel.page), scaledX(136), scaledY(69), 0, scaledX(), scaledY())
	love.graphics.setFont(fonts.sans.small)

	gtk.draw(gui)

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		if mouseCollisionScaled(x * 64 - 32, 128 + y * 64, 32, 32) then
			love.graphics.setColor(0,0,0.1)
		else
			love.graphics.setColor(0.1,0.1,0.1)
		end

		love.graphics.rectangle('fill', scaledX(x * 64 - 32), scaledY(128 + y * 64), scaledX(32), scaledY(32))

		love.graphics.setColor(1,1,1)
		if canPlay(levelnum) then
			love.graphics.print(levelnum, scaledX(x * 64 - 30), scaledY(128 + y * 64 + 1), 0, scaledX(), scaledY())
		else
			love.graphics.draw(assets.lock, scaledX(x * 64 - 32), scaledY(128 + y * 64), 0, scaledX(0.25), scaledY(0.25))
		end

		if canPlay(levelnum+1) then
			love.graphics.draw(assets.lvlok, scaledX(x * 64 - 32), scaledY(128 + y * 64), 0, scaledX(0.25), scaledY(0.25))
		end
	end
end

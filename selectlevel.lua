
-- selectlevel.lua: Select level scene

scenes.selectlevel = {}

scenes.selectlevel.page = 1

local gui = {
	back_button = {
		type = "tex_button",
		x = 0, y = 0,
		size = { x = 64, y = 32 },
		texture = "back_btn",
		on_click = function()
			switchState("mainmenu")
		end
	},

	prev_button = {
		type = "tex_button",
		x = 32, y = 64,
		size = { x = 32, y = 32 },
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
		texture = "arrow_right",
		on_click = function()
			scenes.selectlevel.page = scenes.selectlevel.page + 1
		end,
		is_visible = function()
			return scenes.selectlevel.page ~= 4
		end
	},
}

function scenes.selectlevel.update()
	gtk.update(gui)

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = ((scenes.selectlevel.page - 1) * 25 ) + i + 1

		if mouseCollisionScaled(x * 64 - 32, 128 + y * 64, 32, 32) and mouseClick() and levelnum <= game.levelsUnlocked then
			game.level = levelnum
			switchState("game")
		end
	end
end

function scenes.selectlevel.draw()
	love.graphics.setBackgroundColor(64/255, 120/255, 161/255)

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.print("Page: "..scenes.selectlevel.page, scaledX(136), scaledY(69), 0, scaledX(), scaledY())
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
		if levelnum <= game.levelsUnlocked then
			love.graphics.print(levelnum, scaledX(x * 64 - 30), scaledY(128 + y * 64 + 1), 0, scaledX(), scaledY())
		else
			love.graphics.draw(assets.lock, scaledX(x * 64 - 32), scaledY(128 + y * 64), 0, scaledX(), scaledY())
		end

		if levelnum < game.levelsUnlocked then
			love.graphics.draw(assets.lvlok, scaledX(x * 64 - 32), scaledY(128 + y * 64), 0, scaledX(), scaledY())
		end
	end
end

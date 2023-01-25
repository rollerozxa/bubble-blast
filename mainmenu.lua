
-- mainmenu.lua: Main menu scene

scenes.mainmenu = {}

local gui = {
	playbtn = {
		type = "button",
		x = 96, y = 8*32,
		size = { x = 160, y = 32 },
		label = S("Play"),
		on_click = function()
			switchState("selectpack")
		end
	},

	helpbtn = {
		type = "button",
		x = 96, y = 10*32,
		size = { x = 160, y = 32 },
		label = S("How to play"),
		on_click = function()
			switchState("help")
		end
	},

	settingsbtn = {
		type = "button",
		x = 96, y = 12*32,
		size = { x = 160, y = 32 },
		label = S("Settings"),
		on_click = function()
			switchState("settings")
		end
	}
}

local bubble_decos = {}

function scenes.mainmenu.init()
	bubble_decos = {}

	for x = 0, (game.base_resolution.x/32)-1, 1 do
		for y = 0, (game.base_resolution.y/32)-1, 1 do
			if math.random(1,4) > 1 then
				table.insert(bubble_decos, {
					x = x,
					y = y,
					state = math.random(1,4)
				})
			end
		end
	end
end

function scenes.mainmenu.update()
	gtk.update(gui)
end

function scenes.mainmenu.draw()
	drawBG(64/255, 148/255, 79/255)

	for _, bubble in ipairs(bubble_decos) do
		love.graphics.draw(assets.bubble[bubble.state], scaledX(bubble.x*32), scaledY(bubble.y*32), 0, scaledX(0.25), scaledY(0.25))
		love.graphics.draw(assets.bubble_eyes, scaledX(bubble.x*32), scaledY(bubble.y*32), 0, scaledX(0.25), scaledY(0.25))
	end

	gtk.draw(gui)


	love.graphics.setFont(fonts.sans.bigger)

	printOutlined("Bubble Blast", 35, 53, 4)
end

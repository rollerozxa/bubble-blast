
-- main.lua: Main script, take care of scenes and initialisations.

game = {
	resolution = {
		x = 352,
		y = 480
	},
	base_resolution = {
		x = 352,
		y = 480
	},
	level = 1,
	levelsUnlocked = 1,
	state = "mainmenu",
	newlyState = true,
	screen_align = "center"
}

offset = {
	x = 0,
	y = 0
}

sparsifier = {}
oldmousedown = false

scenes = {}

json = require("misc.json")

require("i18n")

require("util")

require("game")
require("mainmenu")
require("selectlevel")
require("settings")

require("savegame")
require("fonts")
require("gtk")

local avlusn = require('avlusn')

function love.load()
	-- LÖVE for Android turns the screen to landscape if resizable is true. We do not want this.
	local resizable = love.system.getOS() ~= 'Android'

	love.window.setMode(game.resolution.x, game.resolution.y, { resizable = resizable })
	love.window.setTitle("Bubble Blast")
	love.graphics.setDefaultFilter('nearest', 'nearest', 4)

	assets = {
		bubble = {
			newImage("bubble1"),
			newImage("bubble2"),
			newImage("bubble3"),
			newImage("bubble4")
		},
		bubble_eyes = newImage("bubble_eyes"),
		eyes_squint = newImage("eyes_squint"),
		eyes_closed = newImage("eyes_closed"),
		particle	= newImage("particle"),
		refresh		= newImage("refresh"),
		debug_grid	= newImage("_debug_grid"),
		lvlok		= newImage("lvlok"),
		lock		= newImage("lock"),
		back_btn	= newImage("back_btn"),
		arrow_left	= newImage("arrow_left"),
		arrow_right	= newImage("arrow_right")
	}

	fonts = initFonts()

	sounds = {
		pop = newSound("pop"),
		success = newSound("success"),
	}

	savegame.load()
	if savegame.get('levelsUnlocked') then
		game.levelsUnlocked = savegame.get('levelsUnlocked')
	end
end

function love.update()
	if game.newlyState then
		if scenes[game.state].init ~= nil then
			scenes[game.state].init()
		end

		game.newlyState = false
	end

	if scenes[game.state].update ~= nil then
		scenes[game.state].update()
	end

	oldmousedown = love.mouse.isDown(1)

	if love.keyboard.isDown('f3') then
		for id, def in pairs(avlusn) do
			if love.keyboard.isDown(def.keybind) and not sparsifier[def.keybind] then
				avlusn[id].enabled = not avlusn[id].enabled
			end
			sparsifier[def.keybind] = love.keyboard.isDown(def.keybind)
		end
	end

	if love.keyboard.isDown('lctrl') and love.keyboard.isDown('q') then
		love.event.quit()
	end
end

function love.draw()
	love.graphics.translate(offset.x, offset.y)

	if scenes[game.state].draw ~= nil then
		scenes[game.state].draw()
	end

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.setColor(1,1,1)

	for id, def in pairs(avlusn) do
		if def.enabled then
			def.draw()
		end
	end
end

function love.resize(w, h)
	game.resolution.x = w
	game.resolution.y = h

	if game.resolution.y / game.resolution.x > 1.36 then
		game.resolution.y = math.ceil(game.resolution.x * 1.36)
	end

	if game.resolution.y / game.resolution.x < 1.36 then
		game.resolution.x = math.ceil(game.resolution.y * 0.733)
	end

	if game.screen_align == "top" then
		local _, y, _, _ = love.window.getSafeArea()
		offset.x = 0
		offset.y = y
	elseif game.screen_align == "center" then
		offset.x = (w - game.resolution.x) / 2
		offset.y = (h - game.resolution.y) / 2
	elseif game.screen_align == "bottom" then
		offset.x = (w - game.resolution.x)
		offset.y = (h - game.resolution.y)
	end
end

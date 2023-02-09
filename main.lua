
-- main.lua: Main script, take care of scenes and initialisations.

--require('level_converter')

game = {
	resolution = {
		x = 352*1.5,
		y = 480*1.5
	},
	base_resolution = {
		x = 352,
		y = 480
	},
	level = 1,
	levelsUnlocked = 1,
	levelpack = 1,
	levelpacksUnlocked = 1,
	presses = 0,
	presses_max = 0,
	state = "mainmenu",
	newlyState = true,
	overlay = false,
	newlyOverlay = false,
	screenAlign = "center",
	fucking_android_back_button_hack = false
}

presses = {}

levels = {}

offset = {
	x = 0,
	y = 0
}

sparsifier = {}
oldmousedown = false

scenes = {}
overlays = {}

json = require("misc.json")

require("i18n")

require("util")

require("game")
require("mainmenu")
require("selectlevel")
require("selectpack")
require("settings")
require("help")

require("lose")
require("pause")
require("success")
require("skip")

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
		lvlok		= newImage("lvlok"),
		lvlskip		= newImage("lvlskip"),
		lock		= newImage("lock"),
		back_btn	= newImage("back_btn"),
		arrow_left	= newImage("arrow_left"),
		arrow_right	= newImage("arrow_right"),
		menu		= newImage("menu"),
	}

	fonts = initFonts()

	sounds = {
		click = newSound("click"),
		lose = newSound("lose"),
		pop = newSound("pop"),
		success = newSound("success"),
	}

	savegame.load()
	game.levelsUnlocked = savegame.get('levelsUnlocked') or 1
	game.screenAlign = savegame.get('screenAlign') or 'center'
	game.levelpacksUnlocked = savegame.get('levelpacksUnlocked') or 1
	if not savegame.get('timesLost') then
		savegame.set('timesLost', 0)
	end

	-- Hardcoded to load levelpack 1
	for i = 1, 5, 1 do
		local leveljson = love.filesystem.read("levelpacks/"..i..".json")
		local leveldata = json.decode(leveljson)
		levels[i] = leveldata.levels
	end

	-- Hardcode main menu scene init
	scenes.mainmenu.init()
end

function love.update()
	if scenes[game.state].update ~= nil then
		scenes[game.state].update()
	end

	if game.overlay then
		if overlays[game.overlay].update ~= nil then
			overlays[game.overlay].update()
		end
	end

	oldmousedown = love.mouse.isDown(1)

	game.fucking_android_back_button_hack = false

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

	if not newlyState then
		if scenes[game.state].draw ~= nil then
			scenes[game.state].draw()
		end
	end

	if game.overlay then
		if overlays[game.overlay].draw ~= nil then
			overlays[game.overlay].draw()
		end
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

	if game.screenAlign == "top" then
		local _, y, _, _ = love.window.getSafeArea()
		offset.x = 0
		offset.y = y
	elseif game.screenAlign == "center" then
		offset.x = (w - game.resolution.x) / 2
		offset.y = (h - game.resolution.y) / 2
	elseif game.screenAlign == "bottom" then
		offset.x = (w - game.resolution.x)
		offset.y = (h - game.resolution.y)
	end
end

function love.keypressed(key)
	game.fucking_android_back_button_hack = love.system.getOS("Android") and key == "escape"
end

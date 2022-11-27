
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
	presses = 0,
	bubbles = {},
	particles = {},
	state = "mainmenu",
	newlyState = true,
	debug = {
		grid = false,
		info = false
	}
}

scenes = {}

json = require("misc.json")

require("game")
require("mainmenu")
require("selectlevel")
require("util")
require("savegame")
require("fonts")
require("gtk")

function love.load()
	local resizable
	-- LÖVE for Android turns the screen to landscape if resizable is true. We do not want this.
	if love.system.getOS() == 'Android' then
		resizable = false
	else
		resizable = true
	end

	love.window.setMode(game.resolution.x, game.resolution.y, { resizable = resizable })
	love.window.setTitle("Bubble Blast")
	love.graphics.setDefaultFilter( 'nearest', 'nearest', 4 )

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
		backbtn		= newImage("back_btn"),
		arrow = {
			left	= newImage("arrow_left"),
			right	= newImage("arrow_right"),
		}
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
		if love.keyboard.isDown('g') and not oldgriddebug then
			if game.debug.grid then
				game.debug.grid = false
			else
				game.debug.grid = true
			end
		end
		oldgriddebug = love.keyboard.isDown('g')

		if love.keyboard.isDown('f') and not oldinfodebug then
			if game.debug.info then
				game.debug.info = false
			else
				game.debug.info = true
			end
		end
		oldinfodebug = love.keyboard.isDown('f')

		if love.keyboard.isDown('s') and not oldselectdebug then
			game.state = 2
		end
		oldselectdebug = love.keyboard.isDown('s')
	end

	if love.keyboard.isDown('lctrl') and love.keyboard.isDown('q') then
		love.event.quit()
	end
end

function love.draw()
	if scenes[game.state].draw ~= nil then
		scenes[game.state].draw()
	end

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.setColor(1,1,1)

	if game.debug.grid then
		for x = 0,40 do
			for y = 0,40 do
				love.graphics.draw(assets.debug_grid, scaledX(x*32), scaledY(y*32), 0, scaledX(), scaledY())
			end
		end
		love.graphics.print("Debug Grid On", 5, 460)
	end

	if game.debug.info then
		love.graphics.print("FPS: "..love.timer.getFPS()..", Running at "..game.resolution.x.."x"..game.resolution.y, 5, 10)
	end
end

function love.resize(w, h)
	game.resolution.x = w
	game.resolution.y = h

	-- Hack for ultratall devices like my Nokia 5.4.
	if game.resolution.y / game.resolution.x > 2 then
		game.resolution.y = math.ceil(game.resolution.x * 1.36)
	end
end

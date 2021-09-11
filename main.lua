
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
	bubbles = {},
	particles = {},
	state = 1,
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
			NewImage("bubble1"),
			NewImage("bubble2"),
			NewImage("bubble3"),
			NewImage("bubble4")
		},
		bubble_eyes = NewImage("bubble_eyes"),
		particle	= NewImage("particle"),
		refresh		= NewImage("refresh"),
		btn_play	= NewImage("btn_play"),
		debug_grid	= NewImage("_debug_grid"),
		lvlok		= NewImage("lvlok"),
		lock		= NewImage("lock"),
		arrow = {
			left	= NewImage("arrow_left"),
			right	= NewImage("arrow_right"),
		},
		fonts = {
			default = love.graphics.newFont(11),
			defaultMedium = love.graphics.newFont(24),
			defaultBig = love.graphics.newFont(40)
		}
	}

	love.graphics.setFont(assets.fonts.default)

	savegame.load()
	if savegame.get('levelsUnlocked') then
		game.levelsUnlocked = savegame.get('levelsUnlocked')
	end
end

function love.update()
	if game.newlyState then
		if game.state == 3 then
			scenes.game.init()
		end

		game.newlyState = false
	end

	if game.state == 1 then
		scenes.mainmenu.update()
	elseif game.state == 2 then
		scenes.selectlevel.update()
	elseif game.state == 3 then
		scenes.game.update()
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
end

function love.draw()
	love.graphics.setBackgroundColor(0.6, 0.6, 0.6)

	if game.state == 1 then
		scenes.mainmenu.draw()
	elseif game.state == 2 then
		scenes.selectlevel.draw()
	elseif game.state == 3 then
		scenes.game.draw()
	end

	love.graphics.setFont(assets.fonts.default)
	love.graphics.setColor(1,1,1)

	if game.debug.grid then
		for x = 0,40 do
			for y = 0,40 do
				love.graphics.draw(assets.debug_grid, x*32, y*32)
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

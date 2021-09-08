
game = {
	resolution = {
		x = 352,
		y = 480
	},
	bubbles = {},
	particles = {},
	state = 1,
	newlyState = true
}

scenes = {}

require("game")
require("mainmenu")
require("util")

function love.load()
	love.window.setMode(game.resolution.x, game.resolution.y)
	love.window.setTitle("Bubble Blast")

	assets = {
		bubble = {
			NewImage("bubble1"),
			NewImage("bubble2"),
			NewImage("bubble3"),
			NewImage("bubble4")
		},
		particle	= NewImage("particle"),
		refresh		= NewImage("refresh"),
		btn_play	= NewImage("btn_play"),
		fonts = {
			default = love.graphics.newFont(11),
			defaultBig = love.graphics.newFont(40)
		}
	}

	love.graphics.setFont(assets.fonts.default)
end

function love.update()
	if game.newlyState then
		scenes.game.init()

		game.newlyState = false
	end

	if game.state == 1 then
		scenes.mainmenu.update()
	elseif game.state == 2 then
		scenes.game.update()
	end

	oldmousedown = love.mouse.isDown(1)
end

function love.draw()
	love.graphics.setBackgroundColor(0.6, 0.6, 0.6)

	if game.state == 1 then
		scenes.mainmenu.draw()
	elseif game.state == 2 then
		scenes.game.draw()
	end

	love.graphics.setFont(assets.fonts.default)
	love.graphics.print("FPS: "..love.timer.getFPS(), 5, 5)
end

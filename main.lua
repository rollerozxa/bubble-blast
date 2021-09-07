
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

dofile("game.lua")
dofile("mainmenu.lua")
dofile("util.lua")

function love.load()
	love.window.setMode(game.resolution.x, game.resolution.y)
	love.window.setTitle("Bubble Blast")

	assets = {
		bubble = {
			love.graphics.newImage("assets/bubble1.png"),
			love.graphics.newImage("assets/bubble2.png"),
			love.graphics.newImage("assets/bubble3.png"),
			love.graphics.newImage("assets/bubble4.png")
		},
		particle = love.graphics.newImage("assets/particle.png"),
		refresh = love.graphics.newImage("assets/refresh.png"),
		btn_play = love.graphics.newImage("assets/btn_play.png"),
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
